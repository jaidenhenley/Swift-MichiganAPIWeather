import WidgetKit
import AppIntents

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
        let beach = configuration.beach ?? BeachEntity(id: 2, name: "Grand Haven State Park")

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
        let beach = configuration.beach ?? BeachEntity(id: 2, name: "Grand Haven State Park")
        let beachID = beach.id

        var waterTemp = "N/A"
        let crowdLevel = "Unknown"
        let uvIndex = 0
        let condition = "Unknown"

        do {
            let response = try await MichiganWaterAPIService().fetchBeachDetails(beachID: beachID)
            if let tempC = response.buoyData?.waterTempC {
                let tempF = Int(tempC * 9.0 / 5.0 + 32.0)
                waterTemp = "\(tempF)°"
            }
        } catch {
            print("[Widget] fetch error: \(error)")
        }

        let entry = BeachWidgetEntry(
            date: .now,
            beachName: beach.name,
            waterTemp: waterTemp,
            crowdLevel: crowdLevel,
            uvIndex: uvIndex,
            condition: condition
        )

        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: .now)!
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }
}
