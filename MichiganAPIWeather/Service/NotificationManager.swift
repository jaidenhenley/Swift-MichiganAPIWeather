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
    
    func refresh(
        favorites: [Beach],
        scoringService: BeachScoringService,
        weatherService: WeatherKitService,
        userLocation: CLLocation?,
        at time: Date
    ) async {
        
        guard !favorites.isEmpty else {
            cancelAlert()
            return
        }
        
        var conditions: [Int: BeachConditions] = [:]
        
        await withTaskGroup(of: (Int, BeachConditions?).self) { group in
            for beach in favorites {
                group.addTask {
                    let result = await weatherService.fetchConditions(latitude: beach.coordinates.latitude, longitude: beach.coordinates.longitude)
                    return (beach.id, result)
                }
            }
            
            for await (id, condition) in group {
                if let condition {
                    conditions[id] = condition
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
    }
    
    func cancelAlert() {
          UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])
      }
}
