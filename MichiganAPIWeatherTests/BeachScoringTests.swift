//
//  BeachScoringTests.swift
//  MichiganAPIWeatherTests
//
//  Created by Jaiden Henley on 4/24/26.
//

import Testing
import CoreLocation
@testable import MichiganAPIWeather

struct BeachScoringTests {

    // A Fake favorites repository for testing
    
    final class MockFavoritesRepository: FavoritesRepository {
        var favoriteIDs: Set<Int> = []
        
        func isFavorite(beachID: Int) -> Bool {
            let result = favoriteIDs.contains(beachID)
            print("isFavorite(\(beachID)) called, favoriteIDs: \(favoriteIDs), result: \(result)")
            return result        }
        
        func allFavorites() -> [Beach] {
            []
        }
    }

    @Test func favoriteBeachAdds15ToScore() {
        
        let repo = MockFavoritesRepository()
        let service = BeachScoringService(
            favoritesRepo: repo,
            preferences: .default,
            weights: .default
        )
        
        let beach = Beach.allBeaches[0]
        
        let snapshot = ConditionSnapshot(tempF: 72, windSpeedMPH: 12, precipChance: 0.30, uvIndex: 5, date: Date())
        
        let scoreWithoutFavorite = service.score(beach, snapshot: snapshot, type: .today, userLocation: nil).score
        
        repo.favoriteIDs = [beach.id]
        
        let scoreWithFavorite = service.score(beach, snapshot: snapshot, type: .today, userLocation: nil).score
    
        
        #expect(scoreWithFavorite == scoreWithoutFavorite + 15)
    }
    
    @Test func proximityAdds20ToScore() {
        let repo = MockFavoritesRepository()
        let service = BeachScoringService(
            favoritesRepo: repo,
            preferences: .default,
            weights: .default
        )
        
        let beach = Beach.allBeaches[0]
        
        let snapshot = ConditionSnapshot(tempF: 72, windSpeedMPH: 12, precipChance: 0.30, uvIndex: 5, date: Date())

        
        let scoreWithoutLocation = service.score(beach, snapshot: snapshot, type: .today, userLocation: nil).score
        
        let nearbyLocation = CLLocation(
            latitude: beach.coordinates.latitude,
            longitude: beach.coordinates.longitude
        )
        
        let scoreWithLocation = service.score(beach, snapshot: snapshot, type: .today, userLocation: nearbyLocation).score
        
        #expect(scoreWithLocation == scoreWithoutLocation + 20)
    }
    
    @Test func weekendAdds10ToScore() {
        let repo = MockFavoritesRepository()
        let service = BeachScoringService(
            favoritesRepo: repo,
            preferences: .default,
            weights: .default
        )
        
        let calendar = Calendar.current
        let today = Date()

        var weekendDate = today
        for _ in 0..<7 {
            if calendar.isDateInWeekend(weekendDate) { break }
            weekendDate = calendar.date(byAdding: .day, value: 1, to: weekendDate)!
        }

        var weekdayDate = today
        for _ in 0..<7 {
            if !calendar.isDateInWeekend(weekdayDate) { break }
            weekdayDate = calendar.date(byAdding: .day, value: 1, to: weekdayDate)!
        }
        
        let beach = Beach.allBeaches[0]
        
        let weekdaySnapshot = ConditionSnapshot(
            tempF: 72, windSpeedMPH: 12, precipChance: 0.30,
            uvIndex: 5, date: weekdayDate
        )

        let weekendSnapshot = ConditionSnapshot(
            tempF: 72, windSpeedMPH: 12, precipChance: 0.30,
            uvIndex: 5, date: weekendDate
        )
        
        let scoreWithoutWeekend = service.score(beach, snapshot: weekdaySnapshot, type: .today, userLocation: nil).score
        
        let scoreWithWeekend = service.score(beach, snapshot: weekendSnapshot, type: .today, userLocation: nil).score
        
        #expect(scoreWithWeekend == scoreWithoutWeekend + 10)
    }
    
    @Test(arguments: [
        (tempF: 85.0, expectedBucketScore: 25.0),
           (tempF: 77.0, expectedBucketScore: 20.0),
           (tempF: 72.0, expectedBucketScore: 15.0),
           (tempF: 67.0, expectedBucketScore: 8.0),
           (tempF: 50.0, expectedBucketScore: 0.0),
    ]) func temperatureAffectsScore(tempF: Double, expectedBucketScore: Double ) {
        let repo = MockFavoritesRepository()
        let service = BeachScoringService(
            favoritesRepo: repo,
            preferences: .default,
            weights: .default
        )
        let calendar = Calendar.current
        var weekdayDate = Date()
        for _ in 0..<7 {
            if !calendar.isDateInWeekend(weekdayDate) { break }
            weekdayDate = calendar.date(byAdding: .day, value: 1, to: weekdayDate)!
        }
        
        let beach = Beach.allBeaches[0]
                
        let snapshot = ConditionSnapshot(tempF: tempF, windSpeedMPH: 30, precipChance: 0.90, uvIndex: 2, date: weekdayDate)
        
        let actualScore = service.score(
                beach,
                snapshot: snapshot,
                type: .today,
                userLocation: nil
            ).score
        
        #expect(actualScore == expectedBucketScore)
        
    }
}
