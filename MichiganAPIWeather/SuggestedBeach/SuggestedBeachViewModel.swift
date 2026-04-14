//
//  SuggestedBeachViewModel.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/13/26.
//

import CoreLocation
import Foundation

@Observable
@MainActor
class SuggestedBeachViewModel {
    var suggestions: [SuggestedBeach] = []
    var isLoading = false
    
    private let weatherKit = WeatherKitService()
    private let scoringService: BeachScoringService
    
    init(favoritesRepo: FavoritesRepository, preferances: UserBeachPreferences = .default) {
        self.scoringService = BeachScoringService(favoritesRepo: favoritesRepo, preferences: preferances)
    }
    
    func loadSuggestions(userLocation: CLLocation?) async {
        isLoading = true
        defer { isLoading = false }
        
        print("[Suggestions] Loading with location: \(String(describing: userLocation))")
        
        var conditionsMap: [Int: BeachConditions] = [:]
        
        await withTaskGroup(of: (Int, BeachConditions?).self) { group in
            for beach in Beach.allBeaches {
                group.addTask {
                    let conditions = await self.weatherKit.fetchConditions(latitude: beach.coordinates.latitude, longitude: beach.coordinates.longitude)
                    return (beach.id, conditions)
                }
            }
            
            for await (id, conditions) in group {
                if let conditions {
                    conditionsMap[id] = conditions
                }
            }
        }
        
        print("[Suggestions] Fetched conditions for \(conditionsMap.count)/\(Beach.allBeaches.count) beaches")
        
        suggestions = scoringService.topSuggestions(
            from: Beach.allBeaches,
            conditions: conditionsMap,
            userLocation: userLocation
        )
        
        print("[Suggestions] Generated \(suggestions.count) suggestions")
    }
}
