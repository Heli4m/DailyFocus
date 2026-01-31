//
//  Notifications.swift
//  DailyFocus
//
//  Created by Liam Ngo on 30/1/26.
//

import Foundation
import UserNotifications

class Notifications: NSObject {
    static let shared = Notifications()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
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

extension Notifications: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
