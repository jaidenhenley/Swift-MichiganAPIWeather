//
//  NotificationManagerTests.swift
//  MichiganAPIWeatherTests
//
//  Created by Jaiden Henley on 4/29/26.
//

import Testing
import UserNotifications
@testable import MichiganAPIWeather

final class MockNotificationCenter: NotificationScheduling {
    var addedRequests: [UNNotificationRequest] = []
    var removedIdentifiers: [String] = []
    
    func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?) {
        addedRequests.append(request)
    }
    
    func removePendingNotificationRequests(withIdentifiers identifiers: [String]) {
        removedIdentifiers.append(contentsOf: identifiers)
    }
}

final class MockFavoritesRepository: FavoritesRepository {
    var favoriteIDs: Set<Int> = []
    
    func isFavorite(beachID: Int) -> Bool {
        favoriteIDs.contains(beachID)
    }
    
    func allFavorites() -> [Beach] {
        Beach.allBeaches.filter {
            favoriteIDs.contains($0.id)
        }
    }
    
}

@Suite("NotificationManager", .serialized)
struct NotificationManagerTests {

    let mockCenter: MockNotificationCenter
    let manager: NotificationManager
    let mockFavoritesRepo: MockFavoritesRepository
    let scoringService: BeachScoringService
    
    init() {
        mockCenter = MockNotificationCenter()
        manager = NotificationManager(center: mockCenter)
        mockFavoritesRepo = MockFavoritesRepository()
        scoringService = BeachScoringService(favoritesRepo: mockFavoritesRepo)
        UserDefaults.standard.removeObject(forKey: "lastThresholdFired")
        UserDefaults.standard.removeObject(forKey: "lastSevereFired")
    }
    
    @Test("Severe alert fires for Severe severity")
    func severeAlertFiresForSevereSeverity() {
        let beach = Beach.allBeaches[0]
        let alert = AlertFeature(
            event: "Beach Hazards Statement",
            headline: "Test alert",
            severity: "Severe",
            urgency: "Expected",
            effective: "2026-04-29T00:00:00Z",
            expires: "2026-04-30T00:00:00Z")
        let alertsByBeach = [beach.id: [alert]]

        manager.scheduleSevereAlertIfNeeded(alertsByBeach: alertsByBeach, favorites: [beach])

        #expect(mockCenter.addedRequests.count == 1)
        #expect(mockCenter.addedRequests.first?.identifier == manager.severeAlertID)
    }

    @Test("Severe alert skips Minor severity")
    func severeAlertSkipsMinorSeverity() {
        let beach = Beach.allBeaches[0]
        let alert = AlertFeature(
            event: "Beach Hazards Statement",
            headline: "Test alert",
            severity: "Minor",
            urgency: "Expected",
            effective: "2026-04-29T00:00:00Z",
            expires: "2026-04-30T00:00:00Z")
        let alertsByBeach = [beach.id: [alert]]

        manager.scheduleSevereAlertIfNeeded(alertsByBeach: alertsByBeach, favorites: [beach])

        #expect(mockCenter.addedRequests.isEmpty)
    }

    @Test("Severe alert respects daily cooldown")
    func severeAlertRespectsCoooldown() {
        UserDefaults.standard.set(Date(), forKey: "lastSevereFired")

        let beach = Beach.allBeaches[0]
        let alert = AlertFeature(
            event: "Beach Hazards Statement",
            headline: "Test alert",
            severity: "Severe",
            urgency: "Expected",
            effective: "2026-04-29T00:00:00Z",
            expires: "2026-04-30T00:00:00Z")
        let alertsByBeach = [beach.id: [alert]]

        manager.scheduleSevereAlertIfNeeded(alertsByBeach: alertsByBeach, favorites: [beach])

        #expect(mockCenter.addedRequests.isEmpty)
    }

    @Test("cancelAll removes all three identifiers")
    func cancelAllRemovesAllIdentifiers() {
        manager.cancelAll()

        #expect(mockCenter.removedIdentifiers.contains("top-favorite-beach-alert"))
        #expect(mockCenter.removedIdentifiers.contains("beach-score-threshold-alert"))
        #expect(mockCenter.removedIdentifiers.contains("beach-severe-weather-alert"))
    }
    
    @Test("Threshold alert fires when top score is 70 or above")
    func thresholdAlertFiresAbove70() {
        let beach = Beach.allBeaches[0]
        let snapshot = ConditionSnapshot(
            tempF: 82,
            windSpeedMPH: 5,
            precipChance: 0.0,
            uvIndex: 5,
            date: Date()
        )
        let conditions = [beach.id: BeachConditions(current: snapshot, weekendForecast: snapshot)]

        manager.scheduleThresholdAlert(
            favorites: [beach],
            conditions: conditions,
            scoringService: scoringService,
            userLocation: nil
        )

        #expect(mockCenter.addedRequests.count == 1)
        #expect(mockCenter.addedRequests.first?.identifier == manager.thresholdID)
    }

    @Test("Threshold alert skips when top score is below 70")
    func thresholdAlertSkipsBelowThreshold() {
        let beach = Beach.allBeaches[0]
        let snapshot = ConditionSnapshot(
            tempF: 40,
            windSpeedMPH: 30,
            precipChance: 0.9,
            uvIndex: 0,
            date: Date()
        )
        let conditions = [beach.id: BeachConditions(current: snapshot, weekendForecast: snapshot)]

        manager.scheduleThresholdAlert(
            favorites: [beach],
            conditions: conditions,
            scoringService: scoringService,
            userLocation: nil
        )

        #expect(mockCenter.addedRequests.isEmpty)
    }

    @Test("Threshold alert respects daily cooldown")
    func thresholdAlertRespectsCoooldown() {
        UserDefaults.standard.set(Date(), forKey: "lastThresholdFired")
        let beach = Beach.allBeaches[0]
        let snapshot = ConditionSnapshot(
            tempF: 82,
            windSpeedMPH: 5,
            precipChance: 0.0,
            uvIndex: 5,
            date: Date()
        )
        let conditions = [beach.id: BeachConditions(current: snapshot, weekendForecast: snapshot)]

        manager.scheduleThresholdAlert(
            favorites: [beach],
            conditions: conditions,
            scoringService: scoringService,
            userLocation: nil
        )

        #expect(mockCenter.addedRequests.isEmpty)
    }
    
    @Test("Severe alert title includes beach name")
    func severeAlertTitleIncludesBeachName() {
        let beach = Beach.allBeaches[0]
        let alert = AlertFeature(
            event: "Beach Hazards Statement",
            headline: "Dangerous swim conditions expected",
            severity: "Severe",
            urgency: "Expected",
            effective: "2026-04-29T00:00:00Z",
            expires: "2026-04-30T00:00:00Z"
        )

        manager.scheduleSevereAlertIfNeeded(alertsByBeach: [beach.id: [alert]], favorites: [beach])

        let content = mockCenter.addedRequests.first?.content
        #expect(content?.title == "Weather Alert: \(beach.beachName)")
        #expect(content?.body == alert.headline)
        #expect(content?.sound == .defaultCritical)
    }

    @Test("Threshold alert title includes beach name")
    func thresholdAlertTitleIncludesBeachName() {
        let beach = Beach.allBeaches[0]
        let snapshot = ConditionSnapshot(
            tempF: 82,
            windSpeedMPH: 5,
            precipChance: 0.0,
            uvIndex: 5,
            date: Date()
        )
        let conditions = [beach.id: BeachConditions(current: snapshot, weekendForecast: snapshot)]

        manager.scheduleThresholdAlert(
            favorites: [beach],
            conditions: conditions,
            scoringService: scoringService,
            userLocation: nil
        )

        let content = mockCenter.addedRequests.first?.content
        #expect(content?.title == "\(beach.beachName) is looking great today")
        #expect(content?.sound == .default)
    }
}
