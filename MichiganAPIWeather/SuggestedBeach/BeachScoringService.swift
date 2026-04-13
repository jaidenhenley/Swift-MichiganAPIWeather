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
    
    init(favoritesRepo: FavoritesRepository) {
        self.favoritesRepo = favoritesRepo
    }
    
    func score(_ beach: Beach, conditions: BeachConditions, userLocation: CLLocation?) -> SuggestedBeach {
            var score = baseScore(from: conditions)
            let reason = primaryReason(from: conditions)
            
            if favoritesRepo.isFavorite(beachID: beach.id) {
                score += 15
            }
            
            if let location = userLocation, isNearby(beach, to: location) {
                score += 20
            }
            
            return SuggestedBeach(beach: beach, score: score, reason: reason)
        }
    
    func topSuggestions(from beaches: [Beach], conditions: [Int: BeachConditions], userLocation: CLLocation?) -> [SuggestedBeach] {
            beaches
                .map { score($0, conditions: conditions[$0.id] ?? .default, userLocation: userLocation) }
                .sorted { $0.score > $1.score }
                .prefix(3)
                .map { $0 }
        }
    
    private func baseScore(from conditions: BeachConditions) -> Double {
        var score = 0.0

        // Temperature (0–25 pts)
        score += temperatureScore(conditions.tempF)

        // Wind speed (0–25 pts) — lower is better
        score += windScore(conditions.windSpeedMPH)

        // Precipitation probability (0–25 pts)
        score += precipScore(conditions.precipChance)

        // UV index — bonus for good beach hours (0–15 pts)
        score += uvScore(Double(conditions.uvIndex))

        // Weekend bonus (0–10 pts)
        score += conditions.isWeekend ? 10 : 0
        
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
        case 3..<8: return 15  // ideal beach UV
        case 8..<10: return 8  // high but manageable
        default: return 0
        }
    }
    private func primaryReason(from conditions: BeachConditions) -> String {
        if conditions.precipChance >= 0.6 {
            return "High chance of rain"
        }
        if conditions.windSpeedMPH >= 20 {
            return "Very windy today"
        }
        if conditions.tempF >= 80 {
            return "Perfect beach weather"
        }
        if conditions.tempF >= 70 {
            return "Warm and comfortable"
        }
        if conditions.uvIndex >= 8 {
            return "High UV — bring sunscreen"
        }
        if conditions.windSpeedMPH <= 10 && conditions.precipChance <= 0.2 {
            return "Calm conditions today"
        }
        return "Decent conditions today"
    }
    
    private func isNearby(_ beach: Beach, to userLocation: CLLocation) -> Bool {
        let beachLocation = CLLocation(latitude: beach.coordinates.latitude, longitude: beach.coordinates.longitude)
        let distanceMeters = userLocation.distance(from: beachLocation)
        let distanceMiles = distanceMeters / 1609.34
        
        return distanceMiles <= 30 // TODO: Change to users preferred distance

    }
}
