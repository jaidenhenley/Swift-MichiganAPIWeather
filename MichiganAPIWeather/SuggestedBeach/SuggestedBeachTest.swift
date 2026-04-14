//
//  SuggestedBeachTest.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/13/26.
//

import CoreLocation
import SwiftUI

struct SuggestedBeachTest: View {
    @State private var suggestions: [SuggestedBeach] = []
    @Environment(\.modelContext) private var context
    
    var body: some View {
        List(suggestions, id: \.beach.id) { suggestion in
            VStack(alignment: .leading) {
                Text(suggestion.beach.beachName)
                    .font(.headline)
                Text(suggestion.reason)
                    .font(.subheadline)
                Text("Score: \(Int(suggestion.score))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .onAppear { loadDebugSuggestions() }
        .navigationTitle("Suggested Beaches Debug")
    }
    
    private func loadDebugSuggestions() {
         let repo = LocalFavoritesRepository(context: context)
         let service = BeachScoringService(favoritesRepo: repo)
         
         // Hardcoded conditions — tweak these to test different scenarios
         let snapshot = ConditionSnapshot(
             tempF: 78,
             windSpeedMPH: 8,
             precipChance: 0.15,
             uvIndex: 6,
             date: .now
         )
         var conditions: [Int: BeachConditions] = [:]
         for beach in Beach.allBeaches {
             conditions[beach.id] = BeachConditions(
                 current: snapshot,
                 weekendForecast: snapshot
             )
         }
         
         // Simulate Detroit user location
         let detroit = CLLocation(latitude: 42.3314, longitude: -83.0458)
         
         suggestions = service.topSuggestions(
             from: Beach.allBeaches,
             conditions: conditions,
             userLocation: detroit
         )
     }
}

#Preview {
    SuggestedBeachTest()
}
