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
            intent: GetBeachConditionsIntent(),
            phrases: [
                "Get beach conditions in \(.applicationName)",
                "Check \(\.$beach) in \(.applicationName)",
                "What's the water like at \(\.$beach) in \(.applicationName)",
                "Show me \(\.$beach) in \(.applicationName)",
            ],
            shortTitle: "Beach Conditions",
            systemImageName: "water.waves"
        )
    }
}
