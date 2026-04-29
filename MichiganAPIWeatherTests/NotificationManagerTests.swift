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

@Suite("NotificationManager", .serialized)
struct NotificationManagerTests {

    let mockCenter: MockNotificationCenter
    let manager: NotificationManager
    
    init() {
        mockCenter = MockNotificationCenter()
        manager = NotificationManager(center: mockCenter)
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

}
