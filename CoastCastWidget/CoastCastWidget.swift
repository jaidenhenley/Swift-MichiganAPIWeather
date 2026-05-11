import WidgetKit
import SwiftUI
import WeatherKit
import CoreLocation

struct BeachWidgetEntry: TimelineEntry {
    let date: Date
    let beachName: String
    let imageName: String
    let airTemp: String
    let waterTemp: String
    let crowdLevel: String
    let uvIndex: Int
    let condition: String
}

struct BeachProvider: AppIntentTimelineProvider {
    private let weatherService = WeatherService.shared

    func placeholder(in context: Context) -> BeachWidgetEntry {
        sampleEntry(beachName: "Grand Haven", imageName: "grandHaven1")
    }

    func snapshot(for configuration: SelectBeachIntent, in context: Context) async -> BeachWidgetEntry {
        let beach = configuration.beach ?? BeachEntity.allBeaches[1]

        guard !context.isPreview else {
            return sampleEntry(beachName: beach.name, imageName: beach.imageName)
        }

        return await liveEntry(for: beach)
    }

    func timeline(for configuration: SelectBeachIntent, in context: Context) async -> Timeline<BeachWidgetEntry> {
        let beach = configuration.beach ?? BeachEntity.allBeaches[1]
        let entry = await liveEntry(for: beach)
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: .now) ?? .now.addingTimeInterval(1800)

        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }

    private func liveEntry(for beach: BeachEntity) async -> BeachWidgetEntry {
        async let beachDetails = fetchBeachDetails(beachID: beach.id)
        async let weather = fetchWeather(latitude: beach.latitude, longitude: beach.longitude)

        let details = await beachDetails
        let weatherSnapshot = await weather
        let waterTempF = details?.waterTempF

        return BeachWidgetEntry(
            date: .now,
            beachName: beach.name,
            imageName: beach.imageName,
            airTemp: weatherSnapshot.map { "\($0.temperatureF)°" } ?? "N/A",
            waterTemp: waterTempF.map { "\($0)°" } ?? "N/A",
            crowdLevel: crowdLevel(weather: weatherSnapshot, waterTempF: waterTempF, isHoliday: details?.holiday ?? false),
            uvIndex: weatherSnapshot?.uvIndex ?? 0,
            condition: weatherSnapshot?.condition ?? "Unknown"
        )
    }

    private func sampleEntry(beachName: String, imageName: String) -> BeachWidgetEntry {
        BeachWidgetEntry(
            date: .now,
            beachName: beachName,
            imageName: imageName,
            airTemp: "70°",
            waterTemp: "52°",
            crowdLevel: "Moderate",
            uvIndex: 5,
            condition: "Sunny"
        )
    }

    private func fetchBeachDetails(beachID: Int) async -> WidgetBeachDetails? {
        do {
            let url = URL(string: "https://michiganwaterapi.onrender.com/beaches/\(beachID)/details")!
            let (data, urlResponse) = try await URLSession.shared.data(from: url)

            guard let httpResponse = urlResponse as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                return nil
            }

            let decodedResponse = try JSONDecoder().decode(WidgetBeachResponse.self, from: data)
            let waterTempF = decodedResponse.buoyData?.waterTempC.map { Int(($0 * 9.0 / 5.0 + 32.0).rounded()) }
            return WidgetBeachDetails(waterTempF: waterTempF, holiday: decodedResponse.holiday)
        } catch {
            print("[Widget] beach details fetch error: \(error)")
            return nil
        }
    }

    private func fetchWeather(latitude: Double, longitude: Double) async -> WidgetWeatherSnapshot? {
        do {
            let location = CLLocation(latitude: latitude, longitude: longitude)
            let weather = try await weatherService.weather(for: location, including: .current, .daily)
            let current = weather.0
            let today = weather.1.first

            return WidgetWeatherSnapshot(
                temperatureF: Int(current.temperature.converted(to: .fahrenheit).value.rounded()),
                condition: current.condition.description,
                uvIndex: current.uvIndex.value,
                highF: today.map { Int($0.highTemperature.converted(to: .fahrenheit).value.rounded()) },
                lowF: today.map { Int($0.lowTemperature.converted(to: .fahrenheit).value.rounded()) },
                precipitationChance: today?.precipitationChance ?? 0,
                windSpeedMph: (today?.wind.speed ?? current.wind.speed).converted(to: .milesPerHour).value
            )
        } catch {
            print("[Widget] WeatherKit fetch error: \(error)")
            return nil
        }
    }

    private func crowdLevel(weather: WidgetWeatherSnapshot?, waterTempF: Int?, isHoliday: Bool) -> String {
        guard let weather else { return "Unknown" }

        var score = 0
        let maxTemp = weather.highF ?? weather.temperatureF
        let minTemp = weather.lowF ?? weather.temperatureF
        let waterTemp = waterTempF ?? seasonalWaterTempF(for: .now)

        if isHoliday || Calendar.current.isDateInWeekend(.now) { score += 2 }
        if maxTemp >= 82 { score += 2 } else if maxTemp >= 72 { score += 1 }
        if minTemp >= 62 { score += 1 }
        if waterTemp >= 65 { score += 2 } else if waterTemp >= 55 { score += 1 }
        if weather.uvIndex >= 6 { score += 1 }
        if weather.precipitationChance >= 0.5 { score -= 2 } else if weather.precipitationChance >= 0.25 { score -= 1 }
        if weather.windSpeedMph >= 20 { score -= 2 } else if weather.windSpeedMph >= 14 { score -= 1 }

        switch score {
        case 5...:
            return "Busy"
        case 2...4:
            return "Moderate"
        default:
            return "Not Busy"
        }
    }

    private func seasonalWaterTempF(for date: Date) -> Int {
        let month = Calendar.current.component(.month, from: date)
        let monthlyWaterTemp = [4: 41, 5: 48, 6: 57, 7: 67, 8: 70, 9: 62, 10: 52, 11: 43]
        return monthlyWaterTemp[month] ?? 55
    }
}

private struct WidgetBeachDetails {
    let waterTempF: Int?
    let holiday: Bool
}

private struct WidgetWeatherSnapshot {
    let temperatureF: Int
    let condition: String
    let uvIndex: Int
    let highF: Int?
    let lowF: Int?
    let precipitationChance: Double
    let windSpeedMph: Double
}

private struct WidgetBeachResponse: Decodable {
    let buoyData: WidgetBuoyData?
    let holiday: Bool

    enum CodingKeys: String, CodingKey {
        case buoyData = "buoyData"
        case holiday
    }
}

private struct WidgetBuoyData: Decodable {
    let waterTempC: Double?

    enum CodingKeys: String, CodingKey {
        case waterTempC = "water_temp_c"
    }
}

struct CoastCastWidgetView: View {
    let entry: BeachWidgetEntry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        switch family {
        case .systemSmall:
            smallView
        case .systemMedium:
            mediumView
        default:
            smallView
        }
    }

    private var smallView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(shortBeachName)
                .font(.system(size: 16, weight: .black, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.65)
                .foregroundStyle(Color(red: 0.00, green: 0.38, blue: 0.45))
                .frame(height: 19, alignment: .bottom)

            HStack(spacing: 8) {
                WidgetSmallTempCard(label: "AIR", value: entry.airTemp)
                WidgetSmallTempCard(label: "WATER", value: entry.waterTemp)
            }

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 6) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 12, weight: .bold))
                    Text(entry.crowdLevel.uppercased())
                        .font(.system(size: 10, weight: .heavy))
                        .lineLimit(1)
                        .minimumScaleFactor(0.65)
                }
                .foregroundStyle(Color(red: 0.00, green: 0.38, blue: 0.45))

                WidgetSmallCrowdBar(level: entry.crowdLevel)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.18), in: RoundedRectangle(cornerRadius: 14))

            Label("UV \(entry.uvIndex)", systemImage: "sun.max.fill")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(Color(red: 0.00, green: 0.38, blue: 0.45))
                .labelStyle(.titleAndIcon)
        }
        .padding(.horizontal, 14)
        .padding(.top, 14)
        .padding(.bottom, 18)
        .containerBackground(
            LinearGradient(
                colors: [
                    Color(red: 0.92, green: 0.82, blue: 0.04),
                    Color(red: 0.74, green: 0.84, blue: 0.82)
                ],
                startPoint: .top,
                endPoint: .bottom
            ),
            for: .widget
        )
    }

    private var shortBeachName: String {
        entry.beachName
            .replacingOccurrences(of: " State Park", with: "")
            .replacingOccurrences(of: " National Lakeshore", with: "")
            .replacingOccurrences(of: " County Park", with: "")
            .replacingOccurrences(of: " Beach", with: "")
    }

    private var mediumView: some View {
        HStack(alignment: .top, spacing: 13) {
            VStack(alignment: .leading, spacing: 8) {
                Image(entry.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 124, height: 88)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                WidgetBeachNameText(entry.beachName)
                    .frame(width: 124, alignment: .leading)
            }
            .frame(width: 124)

            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 10) {
                    WidgetTempCard(label: "AIR TEMP", value: entry.airTemp)
                    WidgetTempCard(label: "WATER TEMP", value: entry.waterTemp)
                }

                VStack(alignment: .leading, spacing: 7) {
                    WidgetCrowdHeader()
                    WidgetCrowdBar(level: entry.crowdLevel)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .containerBackground(
            LinearGradient(
                colors: [
                    Color(red: 0.92, green: 0.82, blue: 0.04),
                    Color(red: 0.74, green: 0.84, blue: 0.82)
                ],
                startPoint: .top,
                endPoint: .bottom
            ),
            for: .widget
        )
    }
}

private struct WidgetBeachNameText: View {
    let name: String

    init(_ name: String) {
        self.name = name
    }

    var body: some View {
        Text(shortName)
            .font(.system(size: 20, weight: .black, design: .rounded))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            .foregroundStyle(.white)
            .shadow(color: .white, radius: 0, x: 0, y: 1)
            .shadow(color: .white, radius: 0, x: 1, y: 0)
            .shadow(color: Color(red: 0.00, green: 0.42, blue: 0.45), radius: 0, x: -1.3, y: 0)
            .shadow(color: Color(red: 0.00, green: 0.42, blue: 0.45), radius: 0, x: 1.3, y: 0)
            .shadow(color: Color(red: 0.00, green: 0.42, blue: 0.45), radius: 0, x: 0, y: -1.3)
            .shadow(color: Color(red: 0.00, green: 0.42, blue: 0.45), radius: 0, x: 0, y: 1.3)
    }

    private var shortName: String {
        name
            .replacingOccurrences(of: " State Park", with: "")
            .replacingOccurrences(of: " National Lakeshore", with: "")
            .replacingOccurrences(of: " County Park", with: "")
            .replacingOccurrences(of: " Beach", with: "")
    }
}

private struct WidgetSmallTempCard: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 3) {
            Text(label)
                .font(.system(size: 10, weight: .black))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .foregroundStyle(Color(red: 0.00, green: 0.38, blue: 0.45))

            Text(value)
                .font(.system(size: 23, weight: .black))
                .lineLimit(1)
                .minimumScaleFactor(0.55)
                .foregroundStyle(.black)
        }
        .frame(maxWidth: .infinity, minHeight: 52)
        .background(Color.white.opacity(0.28), in: RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color(red: 0.00, green: 0.43, blue: 0.48).opacity(0.55), lineWidth: 1)
        )
    }
}

private struct WidgetTempCard: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 7) {
            Text(label)
                .font(.system(size: 11, weight: .bold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .foregroundStyle(Color(red: 0.00, green: 0.38, blue: 0.45))

            Text(value)
                .font(.system(size: 29, weight: .black))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .foregroundStyle(.black)
        }
        .frame(width: 72, height: 72)
        .padding(.horizontal, 4)
        .padding(.vertical, 3)
        .background(Color(red: 0.75, green: 0.86, blue: 0.74).opacity(0.58), in: RoundedRectangle(cornerRadius: 21))
        .overlay(
            RoundedRectangle(cornerRadius: 21)
                .stroke(Color(red: 0.00, green: 0.43, blue: 0.48).opacity(0.55), lineWidth: 1)
        )
    }
}

private struct WidgetCrowdHeader: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "person.3.fill")
                .font(.system(size: 20, weight: .bold))
            Text("CROWD METER")
                .font(.system(size: 18, weight: .heavy))
                .lineLimit(1)
                .minimumScaleFactor(0.55)
        }
        .foregroundStyle(Color(red: 0.00, green: 0.38, blue: 0.45))
        .frame(maxWidth: .infinity, minHeight: 26, alignment: .leading)
        .padding(.horizontal, 5)
        .background(Color(red: 0.69, green: 0.84, blue: 0.85).opacity(0.72))
    }
}

private struct WidgetSmallCrowdBar: View {
    let level: String

    private var filledSegments: Int {
        switch level.lowercased() {
        case "low", "not busy": return 1
        case "moderate": return 2
        case "high", "busy": return 5
        default: return 0
        }
    }

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<6, id: \.self) { index in
                RoundedRectangle(cornerRadius: 4)
                    .fill(index < filledSegments ? Color(red: 0.18, green: 0.82, blue: 0.36) : Color(red: 0.82, green: 0.86, blue: 0.82).opacity(0.7))
            }
        }
        .frame(height: 13)
    }
}

private struct WidgetCrowdBar: View {
    let level: String

    private var filledSegments: Int {
        switch level.lowercased() {
        case "low", "not busy": return 1
        case "moderate": return 2
        case "high", "busy": return 5
        default: return 0
        }
    }

    private var barColor: Color {
        switch level.lowercased() {
        case "low", "not busy": return .green
        case "moderate": return .yellow
        case "high", "busy": return .red
        default: return .gray
        }
    }

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<6, id: \.self) { index in
                Rectangle()
                    .fill(index < filledSegments ? barColor : Color(red: 0.82, green: 0.86, blue: 0.82).opacity(0.75))
            }
        }
        .frame(height: 22)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color(red: 0.00, green: 0.43, blue: 0.48).opacity(0.6), lineWidth: 1)
        )
    }
}

struct CoastCastWidget: Widget {
    let kind: String = "CoastCastWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: SelectBeachIntent.self, provider: BeachProvider()) { entry in
            CoastCastWidgetView(entry: entry)
        }
        .configurationDisplayName("Beach Conditions")
        .description("See current conditions at your favorite Michigan beach.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}
