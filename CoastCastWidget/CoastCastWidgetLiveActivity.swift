import ActivityKit
import WidgetKit
import SwiftUI

struct BeachActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var crowdLevel: String
        var waterTemp: String
        var uvIndex: Int
    }

    let beachName: String
}

struct CoastCastLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BeachActivityAttributes.self) { context in
            HStack {
                Text("🏖️ \(context.attributes.beachName)")
                    .bold()
                Spacer()
                Text("💧 \(context.state.waterTemp)")
                Text("👥 \(context.state.crowdLevel)")
            }
            .padding()
            .containerBackground(.teal.opacity(0.2), for: .widget)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("🏖️ \(context.attributes.beachName)")
                        .bold()
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("💧 \(context.state.waterTemp)")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Text("👥 \(context.state.crowdLevel)")
                        Spacer()
                        Text("☀️ UV \(context.state.uvIndex)")
                    }
                }
            } compactLeading: {
                Text("🏖️")
            } compactTrailing: {
                Text(context.state.waterTemp)
            } minimal: {
                Text("🏖️")
            }
        }
    }
}
