//
//  NotificationManager.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/15/26.
//

import CoreLocation
import UserNotifications

@Observable
class NotificationManager {
    static let shared = NotificationManager()
    private let notificationID = "top-favorite-beach-alert"
    private let thresholdID = "beach-score-threshold-alert"
    private let severeAlertID = "beach-severe-weather-alert"
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
    func scheduleTopFavoriteAlert(
        favorites: [Beach],
        conditions: [Int: BeachConditions],
        scoringService: BeachScoringService,
        userLocation: CLLocation?,
        at time: Date
    ) {
        guard !favorites.isEmpty else { return }

        let scored = favorites.map {
            scoringService.score(
                $0,
                snapshot: conditions[$0.id]?.current ?? BeachConditions.default.current,
                type: .today,
                userLocation: userLocation
            )
        }

        guard let top = scored.max(by: { $0.score < $1.score }) else { return }

        let content = UNMutableNotificationContent()
        content.title = "Best Beach Today: \(top.beach.beachName)"
        content.body = top.reason
        content.sound = .default

        var components = Calendar.current.dateComponents([.hour, .minute], from: time)
        components.second = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleThresholdAlert(
        favorites: [Beach],
        conditions: [Int: BeachConditions],
        scoringService: BeachScoringService,
        userLocation: CLLocation?
    ) {
        let scored = favorites.map {
            scoringService.score(
                $0,
                snapshot: conditions[$0.id]?.current ?? BeachConditions.default.current,
                type: .today,
                userLocation: userLocation
            )
        }
        guard let top = scored.max(by: { $0.score < $1.score }), top.score >= 70 else { return }

        let content = UNMutableNotificationContent()
        content.title = "\(top.beach.beachName) is looking great today"
        content.body = top.reason
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: thresholdID, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleSevereAlertIfNeeded(alertsByBeach: [Int: [AlertFeature]], favorites: [Beach]) {
        let severeAlerts = favorites.compactMap { beach -> (Beach, AlertFeature)? in
            guard let alerts = alertsByBeach[beach.id] else { return nil }
            let severe = alerts.first { $0.severity == "Severe" || $0.severity == "Extreme" }
            return severe.map { (beach, $0) }
        }
        guard let (beach, alert) = severeAlerts.first else { return }

        let content = UNMutableNotificationContent()
        content.title = "Weather Alert: \(beach.beachName)"
        content.body = alert.headline
        content.sound = .defaultCritical

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: severeAlertID, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func refresh(
        favorites: [Beach],
        scoringService: BeachScoringService,
        weatherService: WeatherKitService,
        apiService: MichiganWaterAPIService,
        userLocation: CLLocation?,
        at time: Date
    ) async {
        guard !favorites.isEmpty else {
            cancelAlert()
            return
        }

        var conditions: [Int: BeachConditions] = [:]
        var alertsByBeach: [Int: [AlertFeature]] = [:]

        let batches = favorites.chunked(into: 3)

        await withTaskGroup(of: (Int, BeachConditions?, [AlertFeature]).self) { group in
            for batch in batches {
                for beach in batch {
                    group.addTask {
                        async let weather = weatherService.fetchConditions(
                            latitude: beach.coordinates.latitude,
                            longitude: beach.coordinates.longitude
                        )
                        async let details = try? apiService.fetchBeachDetails(beachID: beach.id)
                        let (w, d) = await (weather, details)
                        return (beach.id, w, d?.alerts ?? [])
                    }
                }

                for await (id, condition, alerts) in group {
                    if let condition { conditions[id] = condition }
                    alertsByBeach[id] = alerts
                }
            }
        }

        cancelAlert()
        scheduleTopFavoriteAlert(
            favorites: favorites,
            conditions: conditions,
            scoringService: scoringService,
            userLocation: userLocation,
            at: time
        )
        scheduleThresholdAlert(
            favorites: favorites,
            conditions: conditions,
            scoringService: scoringService,
            userLocation: userLocation
        )
        scheduleSevereAlertIfNeeded(alertsByBeach: alertsByBeach, favorites: favorites)
    }
    func cancelAlert() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
