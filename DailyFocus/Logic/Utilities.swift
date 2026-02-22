// Created by Liam Ngo on 18/2/26.
// Purpose: Provides essential shared services such as notifications, JSON data based persistence and haptic feedback.

import Foundation
import SwiftUI
import UserNotifications


/// Requests authorization from users to enable notifications
///
/// requestNotifyPermission should be ran on an early stage of the app's lifecycle, requesting the user for permissions to send notifications. This allows for the timer to end with a notification that can notify the user even when they're outside of the app.
func requestNotifyPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
        if success {
            print("Success")
        } else {
            print("Fail")
        }
    }
}

/// A singleton service responsible for managing all notifications from the app.
class Notifications: NSObject {
    /// Shared instance of Notifications used across the app.
    static let shared = Notifications()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    /// Clears all scheduled and delivered notifications from the app's system.
    func cancelNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    
    /// Schedules a "Time's Up!" notification to fire after a set period of time.
    /// - Parameter secondsRemaining: the delay before the notification fires.
    ///
    /// > Note: Even though scheduleNotification's secondsRemaining is connected to TimerViewModel's secondsRemaining, it may become misaligned.
    ///
    /// > Important: This notification will override any existing notifications due to a set identifier of "DailyFocusTimer".
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
    /// Determines how a notification is presented when the app is in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}


/// Encodes an array of tasks (format: `TaskData`) into the user's device's local storage.
/// - Parameter data: The array of `TaskData` that will be encoded.
///
/// This function formats the array into `JSON` format, which is a format that is suitable for `UserDefaults`.
///
/// > Note: Errors in the saving process are caught and printed into the console to prevent the app from crashing while saving.
func saveData(data: [TaskData]) {
    do {
        let JSONData = try JSONEncoder().encode(data)
        UserDefaults.standard.set(JSONData, forKey: "SavedTasks")
        print("Successfully saved tasks")
    } catch {
        print("Error loading data into JSON")
    }
}


/// Retrieves and decodes the saved task list from local storage.
/// - Returns: The array of `TaskData` that has been retrieved and decoded. The function will return an empty array if no data is found or an error occurs.
func loadData() -> [TaskData] {
    guard let JSONData = UserDefaults.standard.data(forKey: "SavedTasks") else {
        return []
    }
    
    do {
        let data = try JSONDecoder().decode([TaskData].self, from: JSONData)
        return data
    } catch {
        print("Error decoding JSON")
        return []
    }
}

/// Standard wrapper for triggering physical vibration feedbacks
struct Haptics {
    /// Triggers a standard physical impact.
    /// - Parameter style: The feedback style (eg. light, medium, hard,...)
    static func trigger(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    /// Triggers a success notification pattern. (A double pulse)
    static func success() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
    }
    
    /// Triggers a warning notification pattern.
    static func warning() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.warning)
    }
    
    /// Triggers an error notification pattern.
    static func error() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.error)
    }
}
