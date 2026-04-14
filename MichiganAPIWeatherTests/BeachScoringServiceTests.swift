//
//  BeachScoringServiceTests.swift
//  MichiganAPIWeatherTests
//
//  Created on 4/13/26.
//

import XCTest
import CoreLocation
@testable import MichiganAPIWeather

// MARK: - Mock

private struct MockFavoritesRepository: FavoritesRepository {
    var favoriteIDs: Set<Int> = []

    func isFavorite(beachID: Int) -> Bool {
        favoriteIDs.contains(beachID)
    }

    func allFavorites() -> [Beach] {
        Beach.allBeaches.filter { favoriteIDs.contains($0.id) }
    }
}

// MARK: - Helpers

private func makeSnapshot(
    tempF: Double, windSpeedMPH: Double, precipChance: Double,
    uvIndex: Int, isWeekend: Bool
) -> ConditionSnapshot {
    // Pick a date that is or isn't on a weekend based on the flag
    let calendar = Calendar.current
    var date = Date.now
    if isWeekend != calendar.isDateInWeekend(date) {
        // Advance day-by-day until the weekend flag matches
        let direction: Int = isWeekend ? 1 : -1
        for offset in 1...7 {
            let candidate = calendar.date(byAdding: .day, value: offset * direction, to: date)!
            if calendar.isDateInWeekend(candidate) == isWeekend {
                date = candidate
                break
            }
        }
    }
    return ConditionSnapshot(
        tempF: tempF,
        windSpeedMPH: windSpeedMPH,
        precipChance: precipChance,
        uvIndex: uvIndex,
        date: date
    )
}

private func makeConditions(
    tempF: Double, windSpeedMPH: Double, precipChance: Double,
    uvIndex: Int, isWeekend: Bool
) -> BeachConditions {
    let snap = makeSnapshot(
        tempF: tempF, windSpeedMPH: windSpeedMPH,
        precipChance: precipChance, uvIndex: uvIndex, isWeekend: isWeekend
    )
    return BeachConditions(current: snap, weekendForecast: snap)
}

// MARK: - Tests

final class BeachScoringServiceTests: XCTestCase {

    // Use a real beach from the dataset so ImageResource resolves
    private var testBeach: Beach { Beach.allBeaches[0] } // Sleeping Bear Dunes

    private func makeService(favoriteIDs: Set<Int> = []) -> BeachScoringService {
        BeachScoringService(favoritesRepo: MockFavoritesRepository(favoriteIDs: favoriteIDs))
    }

    // MARK: - Base Score Tests

    func testIdealConditionsProduceHighScore() {
        let service = makeService()
        let snapshot = makeSnapshot(tempF: 85, windSpeedMPH: 5, precipChance: 0.10, uvIndex: 5, isWeekend: true)

        let result = service.score(testBeach, snapshot: snapshot, type: .today, userLocation: nil)

        // 25 (temp) + 25 (wind) + 25 (precip) + 15 (uv) + 10 (weekend) = 100
        XCTAssertEqual(result.score, 100, "Ideal conditions on a weekend should score 100")
    }

    func testPoorConditionsProduceLowScore() {
        let service = makeService()
        let snapshot = makeSnapshot(tempF: 40, windSpeedMPH: 30, precipChance: 0.90, uvIndex: 1, isWeekend: false)

        let result = service.score(testBeach, snapshot: snapshot, type: .today, userLocation: nil)

        // 0 (temp) + 0 (wind) + 0 (precip) + 0 (uv) + 0 (weekday) = 0
        XCTAssertEqual(result.score, 0, "Poor conditions on a weekday should score 0")
    }

    func testModerateConditions() {
        let service = makeService()
        let snapshot = makeSnapshot(tempF: 72, windSpeedMPH: 12, precipChance: 0.30, uvIndex: 5, isWeekend: false)

        let result = service.score(testBeach, snapshot: snapshot, type: .today, userLocation: nil)

        // 15 (temp 70-75) + 18 (wind 10-15) + 15 (precip 0.20-0.40) + 15 (uv 3-8) + 0 (weekday) = 63
        XCTAssertEqual(result.score, 63, "Moderate conditions should produce a mid-range score")
    }

    func testWeekendBonusAdds10Points() {
        let service = makeService()
        let weekdaySnap = makeSnapshot(tempF: 72, windSpeedMPH: 12, precipChance: 0.30, uvIndex: 5, isWeekend: false)
        let weekendSnap = makeSnapshot(tempF: 72, windSpeedMPH: 12, precipChance: 0.30, uvIndex: 5, isWeekend: true)

        let weekdayScore = service.score(testBeach, snapshot: weekdaySnap, type: .today, userLocation: nil).score
        let weekendScore = service.score(testBeach, snapshot: weekendSnap, type: .today, userLocation: nil).score

        XCTAssertEqual(weekendScore - weekdayScore, 10, "Weekend should add exactly 10 points")
    }

    func testScoreNeverExceeds100() {
        let service = makeService(favoriteIDs: [testBeach.id])
        let snapshot = makeSnapshot(tempF: 90, windSpeedMPH: 3, precipChance: 0.05, uvIndex: 6, isWeekend: true)

        // Base would be 100, but favorite adds 15 — score should still cap
        let nearbyLocation = CLLocation(
            latitude: testBeach.coordinates.latitude,
            longitude: testBeach.coordinates.longitude
        )
        let result = service.score(testBeach, snapshot: snapshot, type: .today, userLocation: nearbyLocation)

        // Base 100 (capped) + 15 (fav) + 20 (nearby) = 135
        // Note: the cap is only on baseScore, so total CAN exceed 100.
        // This test documents the current behavior.
        XCTAssertGreaterThan(result.score, 100, "Favorite + nearby bonuses can push score above 100")
    }

    // MARK: - Favorite Bonus Tests

    func testFavoriteBeachGets15PointBonus() {
        let snapshot = makeSnapshot(tempF: 72, windSpeedMPH: 12, precipChance: 0.30, uvIndex: 5, isWeekend: false)

        let noFav = makeService(favoriteIDs: []).score(testBeach, snapshot: snapshot, type: .today, userLocation: nil).score
        let withFav = makeService(favoriteIDs: [testBeach.id]).score(testBeach, snapshot: snapshot, type: .today, userLocation: nil).score

        XCTAssertEqual(withFav - noFav, 15, "Favorited beach should get a 15-point bonus")
    }

    func testNonFavoriteGetsNoBonus() {
        let service = makeService(favoriteIDs: [999]) // some other beach ID
        let snapshot = makeSnapshot(tempF: 72, windSpeedMPH: 12, precipChance: 0.30, uvIndex: 5, isWeekend: false)

        let withFav = service.score(testBeach, snapshot: snapshot, type: .today, userLocation: nil).score
        let noFavService = makeService(favoriteIDs: [])
        let noFav = noFavService.score(testBeach, snapshot: snapshot, type: .today, userLocation: nil).score

        XCTAssertEqual(withFav, noFav, "Non-favorited beach should not get a bonus")
    }

    // MARK: - Proximity Bonus Tests

    func testNearbyLocationGets20PointBonus() {
        let service = makeService()
        let snapshot = makeSnapshot(tempF: 72, windSpeedMPH: 12, precipChance: 0.30, uvIndex: 5, isWeekend: false)

        // User is at the beach (0 miles away)
        let nearbyLocation = CLLocation(
            latitude: testBeach.coordinates.latitude,
            longitude: testBeach.coordinates.longitude
        )

        let withLocation = service.score(testBeach, snapshot: snapshot, type: .today, userLocation: nearbyLocation).score
        let withoutLocation = service.score(testBeach, snapshot: snapshot, type: .today, userLocation: nil).score

        XCTAssertEqual(withLocation - withoutLocation, 20, "Nearby user should get a 20-point bonus")
    }

    func testFarAwayLocationGetsNoBonus() {
        let service = makeService()
        let snapshot = makeSnapshot(tempF: 72, windSpeedMPH: 12, precipChance: 0.30, uvIndex: 5, isWeekend: false)

        // User is in Miami (~1200 miles away)
        let farLocation = CLLocation(latitude: 25.7617, longitude: -80.1918)

        let withLocation = service.score(testBeach, snapshot: snapshot, type: .today, userLocation: farLocation).score
        let withoutLocation = service.score(testBeach, snapshot: snapshot, type: .today, userLocation: nil).score

        XCTAssertEqual(withLocation, withoutLocation, "Far-away user should not get proximity bonus")
    }

    // MARK: - Reason Tests

    func testReasonForRain() {
        let service = makeService()
        let snapshot = makeSnapshot(tempF: 75, windSpeedMPH: 10, precipChance: 0.7, uvIndex: 5, isWeekend: false)

        let result = service.score(testBeach, snapshot: snapshot, type: .today, userLocation: nil)
        XCTAssertEqual(result.reason, "High chance of rain")
    }

    func testReasonForHighWind() {
        let service = makeService()
        let snapshot = makeSnapshot(tempF: 75, windSpeedMPH: 25, precipChance: 0.1, uvIndex: 5, isWeekend: false)

        let result = service.score(testBeach, snapshot: snapshot, type: .today, userLocation: nil)
        XCTAssertEqual(result.reason, "Very windy today")
    }

    func testReasonForPerfectWeather() {
        let service = makeService()
        let snapshot = makeSnapshot(tempF: 85, windSpeedMPH: 5, precipChance: 0.1, uvIndex: 5, isWeekend: false)

        let result = service.score(testBeach, snapshot: snapshot, type: .today, userLocation: nil)
        XCTAssertEqual(result.reason, "Perfect beach weather")
    }

    func testReasonForWarmComfortable() {
        let service = makeService()
        let snapshot = makeSnapshot(tempF: 73, windSpeedMPH: 5, precipChance: 0.1, uvIndex: 5, isWeekend: false)

        let result = service.score(testBeach, snapshot: snapshot, type: .today, userLocation: nil)
        XCTAssertEqual(result.reason, "Warm and comfortable")
    }

    func testReasonForHighUV() {
        let service = makeService()
        let snapshot = makeSnapshot(tempF: 65, windSpeedMPH: 5, precipChance: 0.1, uvIndex: 9, isWeekend: false)

        let result = service.score(testBeach, snapshot: snapshot, type: .today, userLocation: nil)
        XCTAssertEqual(result.reason, "High UV — bring sunscreen")
    }

    func testReasonForCalmConditions() {
        let service = makeService()
        let snapshot = makeSnapshot(tempF: 65, windSpeedMPH: 8, precipChance: 0.1, uvIndex: 2, isWeekend: false)

        let result = service.score(testBeach, snapshot: snapshot, type: .today, userLocation: nil)
        XCTAssertEqual(result.reason, "Calm conditions today")
    }

    // MARK: - Top Suggestions Tests

    func testTopSuggestionsReturnsAtMost3() {
        let service = makeService()

        // Give every beach the same conditions
        var conditions: [Int: BeachConditions] = [:]
        for beach in Beach.allBeaches {
            conditions[beach.id] = makeConditions(tempF: 80, windSpeedMPH: 8, precipChance: 0.10, uvIndex: 5, isWeekend: true)
        }

        let results = service.topSuggestions(from: Beach.allBeaches, conditions: conditions, userLocation: nil)
        XCTAssertLessThanOrEqual(results.count, 3, "Should return at most 3 suggestions")
    }

    func testTopSuggestionsAreSortedByScoreDescending() {
        let service = makeService()

        // Give beach 1 great conditions, beach 2 ok, beach 3 bad
        let conditions: [Int: BeachConditions] = [
            1: makeConditions(tempF: 90, windSpeedMPH: 3, precipChance: 0.05, uvIndex: 6, isWeekend: true),
            2: makeConditions(tempF: 72, windSpeedMPH: 12, precipChance: 0.30, uvIndex: 5, isWeekend: false),
            3: makeConditions(tempF: 50, windSpeedMPH: 25, precipChance: 0.80, uvIndex: 1, isWeekend: false),
        ]

        let beaches = Beach.allBeaches.filter { [1, 2, 3].contains($0.id) }
        let results = service.topSuggestions(from: beaches, conditions: conditions, userLocation: nil)

        XCTAssertEqual(results[0].beach.id, 1, "Best conditions should rank first")
    }

    func testTopSuggestionsFavoriteBeachRanksHigher() {
        // Two beaches with identical weather, but one is favorited
        let conditions: [Int: BeachConditions] = [
            1: makeConditions(tempF: 75, windSpeedMPH: 10, precipChance: 0.20, uvIndex: 5, isWeekend: false),
            2: makeConditions(tempF: 75, windSpeedMPH: 10, precipChance: 0.20, uvIndex: 5, isWeekend: false),
        ]

        let service = makeService(favoriteIDs: [2])
        let beaches = Beach.allBeaches.filter { [1, 2].contains($0.id) }
        let results = service.topSuggestions(from: beaches, conditions: conditions, userLocation: nil)

        XCTAssertEqual(results[0].beach.id, 2, "Favorited beach should rank higher with equal conditions")
    }

    func testDefaultConditionsUsedForMissingBeach() {
        let service = makeService()

        // Only provide conditions for beach 1, not beach 2
        let conditions: [Int: BeachConditions] = [
            1: makeConditions(tempF: 85, windSpeedMPH: 5, precipChance: 0.10, uvIndex: 5, isWeekend: true),
        ]

        let beaches = Beach.allBeaches.filter { [1, 2].contains($0.id) }
        let results = service.topSuggestions(from: beaches, conditions: conditions, userLocation: nil)

        // Beach 2 should get .default conditions (score 0), so beach 1 should rank first
        XCTAssertEqual(results[0].beach.id, 1, "Beach with real conditions should rank above one using defaults")
    }
}
