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
            Text(entry.beachName)
                .bold()
                .font(.caption)
                .lineLimit(1)
            Text("💧 \(entry.waterTemp)")
                .font(.caption)
            Text("👥 \(entry.crowdLevel)")
                .font(.caption)
            Text("☀️ UV \(entry.uvIndex)")
                .font(.caption)
        }
        .padding()
        .containerBackground(.teal.opacity(0.2), for: .widget)
    }

    private var mediumView: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 6) {
                Image(entry.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 72)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    

                Text(entry.beachName)
                    .font(.system(.subheadline, weight: .heavy))
                    .foregroundStyle(Color(red: 0.1, green: 0.35, blue: 0.35))
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(width: 110)

            VStack(spacing: 8) {
                HStack(spacing: 6) {
                    WidgetTempCard(label: "AIR TEMP", value: entry.airTemp)
                    WidgetTempCard(label: "WATER TEMP", value: entry.waterTemp)
                }

                HStack(spacing: 4) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 11))
                    Text("CROWD METER")
                        .font(.system(size: 11, weight: .bold))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(Color(red: 0.15, green: 0.35, blue: 0.35))

                WidgetCrowdBar(level: entry.crowdLevel)
            }
        }
        .padding(12)
        .containerBackground(
            LinearGradient(
                colors: [
                    Color(red: 0.65, green: 0.82, blue: 0.80),
                    Color(red: 0.82, green: 0.85, blue: 0.60)
                ],
                startPoint: .leading,
                endPoint: .trailing
            ),
            for: .widget
        )
    }
}

private struct WidgetTempCard: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.system(size: 9, weight: .bold))
                .foregroundStyle(Color(red: 0.25, green: 0.50, blue: 0.50))
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color(red: 0.1, green: 0.35, blue: 0.35))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(.white.opacity(0.45), in: RoundedRectangle(cornerRadius: 10))
    }
}

private struct WidgetCrowdBar: View {
    let level: String

    private var filledSegments: Int {
        switch level.lowercased() {
        case "low", "not busy": return 2
        case "moderate": return 4
        case "high", "busy": return 6
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
        HStack(spacing: 4) {
            ForEach(0..<6, id: \.self) { index in
                RoundedRectangle(cornerRadius: 3)
                    .fill(index < filledSegments ? barColor : Color(red: 0.75, green: 0.80, blue: 0.75).opacity(0.5))
                    .frame(height: 12)
            }
        }
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
    }
}
