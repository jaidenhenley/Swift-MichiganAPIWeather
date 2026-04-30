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
                "Is the water safe at \(\.$beach) in \(.applicationName)",
                "Is there an E. coli warning at \(\.$beach) in \(.applicationName)",
                "Any advisories at \(\.$beach) in \(.applicationName)",
                "Are there any warnings at \(\.$beach) in \(.applicationName)",
                "Is \(\.$beach) safe to swim in \(.applicationName)",
                "\(.applicationName) alerts for \(\.$beach)",
                "\(.applicationName) is \(\.$beach) safe",
                "\(.applicationName) water quality \(\.$beach)",
            ],
            shortTitle: "Beach Alerts",
            systemImageName: "exclamationmark.triangle"
        )
        
        AppShortcut(
            intent: GetBeachConditionsIntent(),
            phrases: [
                "Check \(\.$beach) in \(.applicationName)",
                "Beach conditions at \(\.$beach) in \(.applicationName)",
                "What are the conditions at \(\.$beach) in \(.applicationName)",
                "What are the conditions like at \(\.$beach) in \(.applicationName)",
                "Tell me \(\.$beach) conditions with \(.applicationName)",
                "What are the conditions at \(\.$beach) with \(.applicationName)",
                "How is \(\.$beach) looking in \(.applicationName)",
                "How does \(\.$beach) look in \(.applicationName)",
                "Is \(\.$beach) good today in \(.applicationName)",
                "Check \(.applicationName) for \(\.$beach) conditions",
                "Get \(\.$beach) conditions from \(.applicationName)",
                "What is \(\.$beach) like in \(.applicationName)",
                "How is the water at \(\.$beach) in \(.applicationName)",
                "What is the weather at \(\.$beach) in \(.applicationName)",
                "Give me conditions for \(\.$beach) in \(.applicationName)",
                "Pull up \(\.$beach) conditions in \(.applicationName)",
                "\(.applicationName) conditions for \(\.$beach)",
                "\(.applicationName) how is \(\.$beach)",
                "\(.applicationName) check \(\.$beach)",
            ],
            shortTitle: "Beach Conditions",
            systemImageName: "speaker.wave.2"
        )
        
        AppShortcut(
            intent: FindClosestBeachIntent(),
            phrases: [
                "Find the closest beach in \(.applicationName)",
                "What beach is near me in \(.applicationName)",
                "Closest beach in \(.applicationName)",
                "What is the nearest beach in \(.applicationName)",
                "Which beach is closest to me in \(.applicationName)",
                "Find a beach near me in \(.applicationName)",
                "What beach is nearby in \(.applicationName)",
                "Show me the nearest beach in \(.applicationName)",
                "Where is the closest beach in \(.applicationName)",
                "Beach near me in \(.applicationName)",
                "Nearest beach in \(.applicationName)",
                "\(.applicationName) find closest beach",
                "\(.applicationName) beach near me",
                "\(.applicationName) nearest beach",
                "\(.applicationName) what beach is close",
                "\(.applicationName) closest beach to me",
            ],
            shortTitle: "Closest Beach",
            systemImageName: "beach.umbrella"
        )
    }
}
