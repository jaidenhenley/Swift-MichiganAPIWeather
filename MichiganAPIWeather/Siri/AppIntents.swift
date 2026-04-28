//
//  AppIntents.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/24/26.
//

import AppIntents
import CoreLocation

struct GetBeachConditionsIntent: AppIntent {
    static var title: LocalizedStringResource = "Get Beach Conditions"
    static var description = IntentDescription("Check current conditions at a Michigan beach")
    static var openAppWhenRun: Bool = true

    static var parameterSummary: some ParameterSummary {
        Summary("Get conditions for \(\.$beach)")
    }

    @Parameter(title: "Beach")
    var beach: BeachEntity

    func perform() async throws -> some IntentResult & ProvidesDialog {
        await MainActor.run {
            NavigationManager.shared.openBeach(id: beach.id)
        }
        return .result(dialog: "Opening \(beach.name) in CoastCast.")
    }
}
