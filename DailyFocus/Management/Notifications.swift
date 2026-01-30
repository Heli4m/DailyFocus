//
//  Notifications.swift
//  DailyFocus
//
//  Created by Liam Ngo on 30/1/26.
//

import Foundation
import UserNotifications

class Notifications {
    static let shared = Notifications()
    
    func cancelNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func scheduleNotification(secondsRemaining: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Time's up!"
        content.body = "Great job staying focused"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Double(secondsRemaining), repeats: false)
        
        let request = UNNotificationRequest(identifier: "DailyFocusTimer", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}
