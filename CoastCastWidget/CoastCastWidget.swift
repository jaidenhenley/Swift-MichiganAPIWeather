import WidgetKit
import SwiftUI

struct BeachWidgetEntry: TimelineEntry {
    let date: Date
    let beachName: String
    let waterTemp: String
    let crowdLevel: String
    let uvIndex: Int
    let condition: String
}

struct BeachProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> BeachWidgetEntry {
        BeachWidgetEntry(
            date: .now,
            beachName: "Grand Haven",
            waterTemp: "52°",
            crowdLevel: "Moderate",
            uvIndex: 5,
            condition: "Sunny"
        )
    }

    func snapshot(for configuration: SelectBeachIntent, in context: Context) async -> BeachWidgetEntry {
        let beach = configuration.beach ?? BeachEntity.allBeaches[1]

        return BeachWidgetEntry(
            date: .now,
            beachName: beach.name,
            waterTemp: "52°",
            crowdLevel: "Moderate",
            uvIndex: 5,
            condition: "Sunny"
        )
    }

    func timeline(for configuration: SelectBeachIntent, in context: Context) async -> Timeline<BeachWidgetEntry> {
        let beach = configuration.beach ?? BeachEntity.allBeaches[1]
        let waterTemp = await fetchWaterTemp(beachID: beach.id)

        let entry = BeachWidgetEntry(
            date: .now,
            beachName: beach.name,
            waterTemp: waterTemp,
            crowdLevel: "Unknown",
            uvIndex: 0,
            condition: "Unknown"
        )

        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: .now)!
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }

    private func fetchWaterTemp(beachID: Int) async -> String {
        do {
            let url = URL(string: "https://michiganwaterapi.onrender.com/beaches/\(beachID)/details")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(WidgetBeachResponse.self, from: data)
            if let tempC = response.buoyData?.waterTempC {
                let tempF = Int(tempC * 9.0 / 5.0 + 32.0)
                return "\(tempF)°"
            }
        } catch {
            print("[Widget] fetch error: \(error)")
        }
        return "N/A"
    }
}

private struct WidgetBeachResponse: Decodable {
    let buoyData: WidgetBuoyData?

    enum CodingKeys: String, CodingKey {
        case buoyData = "buoy_data"
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
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(entry.beachName)
                    .bold()
                    .font(.headline)
                Text(entry.condition)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {
                Text("💧 \(entry.waterTemp)")
                Text("👥 \(entry.crowdLevel)")
                Text("☀️ UV \(entry.uvIndex)")
            }
            .font(.caption)
        }
        .padding()
        .containerBackground(.teal.opacity(0.2), for: .widget)
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
