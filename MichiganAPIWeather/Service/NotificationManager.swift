//
//  NotificationManager.swift
//  MichiganAPIWeather
//
//  Created by Jaiden Henley on 4/15/26.
//

import UserNotifications

@Observable
class NotificationManager {
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
    
    func schedule(for beach: Beach, at date: Date, conditions: BeachConditions) {
        let content = UNMutableNotificationContent()
        content.title = beach.beachName
        content.body = buildBody(from: conditions)
        content.sound = .default
        
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "beach-\(beach.id)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancel(for beach: Beach) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["beach-\(beach.id)"])
    }
    
    private func buildBody(from conditions: BeachConditions) -> String {
        "UV: \(conditions.current.uvIndex), Wind: \(conditions.current.windSpeedMPH)"
    }
}
