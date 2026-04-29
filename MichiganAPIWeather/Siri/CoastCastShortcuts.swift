//
//  CoastCastShortcuts.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/27/26.
//

import AppIntents
import Foundation

struct CoastCastShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: OpenBeachIntent(),
            phrases: [
                "Open \(\.$beach) in \(.applicationName)",
                "Check \(\.$beach) in \(.applicationName)",
                "What's the water like at \(\.$beach) in \(.applicationName)",
                "Show me \(\.$beach) in \(.applicationName)",
                "Beach conditions at \(\.$beach) in \(.applicationName)",
            ],
            shortTitle: "Open Beach",
            systemImageName: "water.waves"
        )
        
        AppShortcut(
            intent: GetBeachConditionsIntent(),
            phrases: [
                "Tell me \(\.$beach) conditions with \(.applicationName)",
                "What are the conditions at \(\.$beach) with \(.applicationName)",
            ],
            shortTitle: "Beach Conditions",
            systemImageName: "speaker.wave.2"
        )
    }
}
