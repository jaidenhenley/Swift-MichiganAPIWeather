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
    private let weights: ScoringWeights

    init(favoritesRepo: FavoritesRepository, preferences: UserBeachPreferences = .default, weights: ScoringWeights = .default) {
        self.favoritesRepo = favoritesRepo
        self.preferences = preferences
        self.weights = weights
    }

    func score(_ beach: Beach, snapshot: ConditionSnapshot, type: SuggestionType, userLocation: CLLocation?) -> SuggestedBeach {
        var score = baseScore(from: snapshot)

        score += tagScore(for: beach)
        score += crowdScore()

        if favoritesRepo.isFavorite(beachID: beach.id) {
            score += weights.favorite
        }

        if let location = userLocation, isWithinTravelLimit(beach, to: location) {
            score += weights.withinTravelLimit
        }

        return SuggestedBeach(beach: beach, score: score, reason: primaryReason(from: snapshot), type: type)
    }

    func topSuggestions(from beaches: [Beach], conditions: [Int: BeachConditions], userLocation: CLLocation?) -> [SuggestedBeach] {
        let filtered = filterByDistance(beaches, userLocation: userLocation)
        var usedIDs = Set<Int>()

        let todayPick = filtered
            .map { score($0, snapshot: conditions[$0.id]?.current ?? BeachConditions.default.current, type: .today, userLocation: userLocation) }
            .sorted { $0.score > $1.score }
            .first { !usedIDs.contains($0.beach.id) }

        if let id = todayPick?.beach.id { usedIDs.insert(id) }

        let weekendPick = filtered
            .map { score($0, snapshot: conditions[$0.id]?.weekendForecast ?? BeachConditions.default.weekendForecast, type: .thisWeekend, userLocation: userLocation) }
            .sorted { $0.score > $1.score }
            .first { !usedIDs.contains($0.beach.id) }

        if let id = weekendPick?.beach.id { usedIDs.insert(id) }

        let topPick = filtered
            .map { score($0, snapshot: conditions[$0.id]?.current ?? BeachConditions.default.current, type: .topPick, userLocation: userLocation) }
            .sorted { $0.score > $1.score }
            .first { !usedIDs.contains($0.beach.id) }

        return [todayPick, weekendPick, topPick].compactMap { $0 }
    }

    // MARK: - Private

    private func baseScore(from snapshot: ConditionSnapshot) -> Double {
        var score = 0.0
        score += temperatureScore(snapshot.tempF)
        score += windScore(snapshot.windSpeedMPH)
        score += precipScore(snapshot.precipChance)
        score += uvScore(Double(snapshot.uvIndex))
        score += Calendar.current.isDateInWeekend(snapshot.date) ? weights.weekendBonus : 0
        return min(score, 100)
    }

    private func temperatureScore(_ temp: Double) -> Double {
        switch temp {
        case 80...: return weights.tempHot
        case 75..<80: return weights.tempWarm
        case 70..<75: return weights.tempMild
        case 65..<70: return weights.tempCool
        default: return 0
        }
    }

    private func windScore(_ speed: Double) -> Double {
        switch speed {
        case 0..<10: return weights.windCalm
        case 10..<15: return weights.windLight
        case 15..<20: return weights.windModerate
        case 20..<25: return weights.windStrong
        default: return 0
        }
    }

    private func precipScore(_ chance: Double) -> Double {
        switch chance {
        case 0..<0.20: return weights.precipLow
        case 0.20..<0.40: return weights.precipMild
        case 0.40..<0.60: return weights.precipModerate
        case 0.60..<0.80: return weights.precipHigh
        default: return 0
        }
    }

    private func uvScore(_ uv: Double) -> Double {
        switch uv {
        case 3..<8: return weights.uvComfortable
        case 8..<10: return weights.uvHigh
        default: return 0
        }
    }

    private func primaryReason(from snapshot: ConditionSnapshot) -> String {
        if snapshot.precipChance >= 0.6 { return "Rain is likely today — might be worth waiting it out" }
        if snapshot.windSpeedMPH >= 20 { return "Strong winds at the shore — waves will be rough" }
        if snapshot.tempF >= 80 { return "Hot, sunny, and absolutely made for the beach" }
        if snapshot.tempF >= 70 { return "Warm temps and comfortable conditions all day" }
        if snapshot.uvIndex >= 8 { return "Great beach day — just don't forget the sunscreen" }
        if snapshot.windSpeedMPH <= 10 && snapshot.precipChance <= 0.2 { return "Calm, clear, and conditions are looking great today" }
        return "Solid conditions — not a bad day for the beach"
    }

    private func tagScore(for beach: Beach) -> Double {
        guard !preferences.amenities.isEmpty else { return 0 }
        let matches = beach.keywords.filter { preferences.amenities.contains($0) }.count
        return Double(matches) * weights.amenityMatchPerTag
    }

    private func crowdScore() -> Double {
        switch preferences.crowdTolerance {
        case .quiet: return weights.crowdQuiet
        case .moderate: return weights.crowdModerate
        case .busy: return weights.crowdBusy
        }
    }

    private func isWithinTravelLimit(_ beach: Beach, to userLocation: CLLocation) -> Bool {
        let beachLocation = CLLocation(latitude: beach.coordinates.latitude, longitude: beach.coordinates.longitude)
        let miles = userLocation.distance(from: beachLocation) / 1609.34
        return miles <= preferences.maxDistance
    }

    private func filterByDistance(_ beaches: [Beach], userLocation: CLLocation?) -> [Beach] {
        guard let location = userLocation else { return beaches }
        let nearby = beaches.filter { isWithinTravelLimit($0, to: location) }
        return nearby.isEmpty ? beaches : nearby
    }
}
