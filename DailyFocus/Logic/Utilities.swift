// Created by Liam Ngo on 18/2/26.
// Purpose: Provides essential shared services such as notifications and haptic feedback.

import Foundation
import SwiftUI
import UserNotifications

func requestNotifyPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        if success {
            print("Success")
        } else {
            print("Fail")
        }
    }
}

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

func saveData(data: [TaskData]) {
    do {
        let JSONData = try JSONEncoder().encode(data) // encodes data
        UserDefaults.standard.set(JSONData, forKey: "SavedTasks") // stores it in UserDefaults (on phone) with the key SavedTasks
        print("Successfully saved tasks")
    } catch {
        print("Error loading data into JSON")
    }
}

func loadData() -> [TaskData] {
    guard let JSONData = UserDefaults.standard.data(forKey: "SavedTasks") else { // takes data from UserDefaults and puts it in a variable
        return []
    }
    
    do {
        let data = try JSONDecoder().decode([TaskData].self, from: JSONData) // decodes data
        return data
    } catch {
        print("Error decoding JSON")
        return []
    }
}

struct Haptics {
    static func trigger(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }
    
    static func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.warning)
    }
    
    static func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.error)
    }
}
