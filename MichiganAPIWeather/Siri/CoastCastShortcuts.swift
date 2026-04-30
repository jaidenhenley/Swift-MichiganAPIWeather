//
//  CoastCastShortcuts.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/27/26.
//

import AppIntents
import Foundation

struct CoastCastShortcuts: AppShortcutsProvider {
    static var shortcutTileColor: ShortcutTileColor = .blue
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: OpenBeachIntent(),
            phrases: [
                "Open \(\.$beach) in \(.applicationName)",
                "Show me \(\.$beach) in \(.applicationName)",
                "Open \(.applicationName) for \(\.$beach)",
                "Show \(.applicationName) for \(\.$beach)",
                "Take me to \(\.$beach) in \(.applicationName)",
                "Launch \(.applicationName) at \(\.$beach)",
            ],
            shortTitle: "Open Beach",
            systemImageName: "water.waves"
        )
        
        AppShortcut(
            intent: GetBeachAlertsIntent(),
            phrases: [
                "Any alerts at \(\.$beach) in \(.applicationName)",
                "Check water quality at \(\.$beach) in \(.applicationName)",
                "Is there an E. coli warning at \(\.$beach) in \(.applicationName)",
                "Any advisories at \(\.$beach) in \(.applicationName)",
                "Are there any warnings at \(\.$beach) in \(.applicationName)",
                "\(.applicationName) alerts for \(\.$beach)",
                "\(.applicationName) water quality \(\.$beach)",
            ],
            shortTitle: "Beach Alerts",
            systemImageName: "exclamationmark.triangle"
        )
        
        AppShortcut(
            intent: GetBeachConditionsIntent(),
            phrases: [
                "Beach conditions at \(\.$beach) in \(.applicationName)",
                "What are the conditions at \(\.$beach) in \(.applicationName)",
                "How is \(\.$beach) looking in \(.applicationName)",
                "What is the weather at \(\.$beach) in \(.applicationName)",
                "\(.applicationName) conditions for \(\.$beach)",
            ],
            shortTitle: "Beach Conditions",
            systemImageName: "speaker.wave.2"
        )
        
        AppShortcut(
            intent: FindClosestBeachIntent(),
            phrases: [
                "Find the closest beach in \(.applicationName)",
                "What beach is near me in \(.applicationName)",
                "Which beach is closest to me in \(.applicationName)",
                "Show me the nearest beach in \(.applicationName)",
                "\(.applicationName) beach near me",
                "\(.applicationName) nearest beach",
            ],
            shortTitle: "Closest Beach",
            systemImageName: "beach.umbrella"
        )
    }
}
