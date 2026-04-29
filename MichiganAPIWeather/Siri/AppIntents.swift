//
//  AppIntents.swift
//  MichiganAPIWeather
//
//  Created by George Clinkscales on 4/24/26.
//

import AppIntents
import CoreLocation

struct OpenBeachIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Beach"
    static var description = IntentDescription("Open a beach page at a Michigan beach")
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

struct GetBeachConditionsIntent: AppIntent {
    static var title: LocalizedStringResource = "Get Beach Condition"
    static var description = IntentDescription("Get Beach Condition at a Michigan Beach")
    static var openAppWhenRun: Bool = false
    
    static var parameterSummary: some ParameterSummary {
        Summary("Get Conditions for \(\.$beach)")
    }
    
    @Parameter(title: "Beach")
    var beach: BeachEntity
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
        guard let matchedBeach = Beach.allBeaches.first(where: { $0.id == beach.id }) else {
            return .result(dialog: "Couldn't find that beach.")
        }

        let weatherService = WeatherKitService()
        guard let conditions = await weatherService.fetchConditions(
            latitude: matchedBeach.coordinates.latitude,
            longitude: matchedBeach.coordinates.longitude
        ) else {
            return .result(dialog: "Couldn't fetch conditions for \(matchedBeach.beachName).")
        }

        let service = BeachScoringService(favoritesRepo: NoFavoritesRepository())
        let result = service.score(
            matchedBeach,
            snapshot: conditions.current,
            type: .today,
            userLocation: nil
        )

        let dialog = "\(matchedBeach.beachName) \(result.siriResponse). Temperature is \(conditions.current.tempF.rounded())"
        return .result(dialog: IntentDialog(stringLiteral: dialog))
    }
}
