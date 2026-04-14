//
//  BeachScoringService.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/13/26.
//

import CoreLocation
import Foundation

class BeachScoringService {
    private let favoritesRepo: FavoritesRepository
    private let preferences: UserBeachPreferences

    init(favoritesRepo: FavoritesRepository, preferences: UserBeachPreferences = .default) {
        self.favoritesRepo = favoritesRepo
        self.preferences = preferences
    }

    func score(_ beach: Beach, snapshot: ConditionSnapshot, type: SuggestionType, userLocation: CLLocation?) -> SuggestedBeach {
        var score = baseScore(from: snapshot)

        score += tagScore(for: beach)
        score += crowdScore()

        if favoritesRepo.isFavorite(beachID: beach.id) {
            score += 15
        }

        if let location = userLocation, isWithinTravelLimit(beach, to: location) {
            score += 20
        }

        return SuggestedBeach(beach: beach, score: score, reason: primaryReason(from: snapshot), type: type)
    }

    func topSuggestions(from beaches: [Beach], conditions: [Int: BeachConditions], userLocation: CLLocation?) -> [SuggestedBeach] {
        let filtered = filterByDistance(beaches, userLocation: userLocation)

        let todayPick = filtered
            .map { score($0, snapshot: conditions[$0.id]?.current ?? BeachConditions.default.current, type: .today, userLocation: userLocation) }
            .sorted { $0.score > $1.score }
            .first

        let weekendPick = filtered
            .map { score($0, snapshot: conditions[$0.id]?.weekendForecast ?? BeachConditions.default.weekendForecast, type: .thisWeekend, userLocation: userLocation) }
            .sorted { $0.score > $1.score }
            .first

        let topPick = filtered
            .map { score($0, snapshot: conditions[$0.id]?.current ?? BeachConditions.default.current, type: .topPick, userLocation: userLocation) }
            .sorted { $0.score > $1.score }
            .first

        return [todayPick, weekendPick, topPick].compactMap { $0 }
    }

    // MARK: - Private

    private func baseScore(from snapshot: ConditionSnapshot) -> Double {
        var score = 0.0
        score += temperatureScore(snapshot.tempF)
        score += windScore(snapshot.windSpeedMPH)
        score += precipScore(snapshot.precipChance)
        score += uvScore(Double(snapshot.uvIndex))
        score += Calendar.current.isDateInWeekend(snapshot.date) ? 10 : 0
        return min(score, 100)
    }

    private func temperatureScore(_ temp: Double) -> Double {
        switch temp {
        case 80...: return 25
        case 75..<80: return 20
        case 70..<75: return 15
        case 65..<70: return 8
        default: return 0
        }
    }

    private func windScore(_ speed: Double) -> Double {
        switch speed {
        case 0..<10: return 25
        case 10..<15: return 18
        case 15..<20: return 10
        case 20..<25: return 4
        default: return 0
        }
    }

    private func precipScore(_ chance: Double) -> Double {
        switch chance {
        case 0..<0.20: return 25
        case 0.20..<0.40: return 15
        case 0.40..<0.60: return 8
        case 0.60..<0.80: return 2
        default: return 0
        }
    }

    private func uvScore(_ uv: Double) -> Double {
        switch uv {
        case 3..<8: return 15
        case 8..<10: return 8
        default: return 0
        }
    }

    private func primaryReason(from snapshot: ConditionSnapshot) -> String {
        if snapshot.precipChance >= 0.6 { return "High chance of rain" }
        if snapshot.windSpeedMPH >= 20 { return "Very windy today" }
        if snapshot.tempF >= 80 { return "Perfect beach weather" }
        if snapshot.tempF >= 70 { return "Warm and comfortable" }
        if snapshot.uvIndex >= 8 { return "High UV — bring sunscreen" }
        if snapshot.windSpeedMPH <= 10 && snapshot.precipChance <= 0.2 { return "Calm conditions today" }
        return "Decent conditions today"
    }

    private func tagScore(for beach: Beach) -> Double {
        guard !preferences.amenities.isEmpty else { return 0 }
        let matches = beach.keywords.filter { preferences.amenities.contains($0) }.count
        return Double(matches) * 5
    }

    private func crowdScore() -> Double {
        switch preferences.crowdTolerance {
        case .quiet: return 10
        case .moderate: return 0
        case .busy: return -10
        }
    }

    private func isWithinTravelLimit(_ beach: Beach, to userLocation: CLLocation) -> Bool {
        let beachLocation = CLLocation(latitude: beach.coordinates.latitude, longitude: beach.coordinates.longitude)
        let miles = userLocation.distance(from: beachLocation) / 1609.34
        return miles <= preferences.maxDistance
    }

    private func filterByDistance(_ beaches: [Beach], userLocation: CLLocation?) -> [Beach] {
        guard let location = userLocation else { return beaches }
        return beaches.filter { isWithinTravelLimit($0, to: location) }
    }
}
