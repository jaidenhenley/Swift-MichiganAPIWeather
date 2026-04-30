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

        let dialog = "\(matchedBeach.beachName) \(result.siriResponse). Temperature is \(Int(conditions.current.tempF.rounded()))°"
        return .result(dialog: IntentDialog(stringLiteral: dialog))
    }
}

struct FindClosestBeachIntent: AppIntent {
    static var title: LocalizedStringResource = "Find Closest Beach"
    static var description = IntentDescription("Finds the Michigan beach closest to your current location.")

    @MainActor
    func perform() async throws -> some ReturnsValue<String> & ProvidesDialog {
        let manager = CLLocationManager()
        
        guard manager.authorizationStatus == .authorizedWhenInUse ||
              manager.authorizationStatus == .authorizedAlways else {
            return .result(
                value: "Location unavailable",
                dialog: "CoastCast needs location access to find the closest beach. Enable it in Settings."
            )
        }

        guard let location = manager.location else {
            return .result(
                value: "Location unavailable",
                dialog: "Couldn't get your current location. Try again in a moment."
            )
        }

        let closest = Beach.allBeaches.min(by: {
            location.distance(from: CLLocation(latitude: $0.coordinates.latitude, longitude: $0.coordinates.longitude)) <
            location.distance(from: CLLocation(latitude: $1.coordinates.latitude, longitude: $1.coordinates.longitude))
        })!

        return .result(
            value: closest.beachName,
            dialog: "The closest beach to you is \(closest.beachName)."
        )
    }
}

struct GetBeachAlertsIntent: AppIntent {
    static var title: LocalizedStringResource = "Get Beach Alerts"
    static var description = IntentDescription("Check water quality and active weather alerts for a beach.")
    
    let service = MichiganWaterAPIService()
    
    @Parameter(title: "Beach")
    var beach: BeachEntity
    
    func perform() async throws -> some ReturnsValue<String> & ProvidesDialog {
        let response = try await service.fetchBeachAlerts(beachId: beach.id)
        
        print("Started Alerts")
        var parts: [String] = []
        
        if let wq = response.waterQuality, !wq.isEmpty {
            let readings = wq.map { "\($0.status) (\($0.value) \($0.unit))" }
            parts.append("Water quality: E. coli levels are \(readings.joined(separator: ", ")).")
        }
        
        if let alerts = response.alerts, !alerts.isEmpty {
            parts.append(contentsOf: alerts.map { "\($0.event): \($0.headline)" })
        }
        
        if parts.isEmpty {
            parts.append("No active alerts or advisories.")
        }
        
        let result = parts.joined(separator: " ")
        return .result(value: result, dialog: "\(result)")
    }
}
