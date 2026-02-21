// Created by Liam Ngo on 30/1/26.
// Purpose: A class that controls the logic of the timer.

import Foundation
import SwiftUI
import UserNotifications

@Observable
class TimerViewModel {
    var secondsRemaining: Int
    var totalSeconds: Int
    var isProcessingATap: Bool = false
    var timerState: TimerStates = .running
    let notifications = Notifications.shared
    
    init(initialSeconds: Int) {
        self.totalSeconds = initialSeconds
        self.secondsRemaining = initialSeconds
    }
    
    var timeString: String {
        let hours = secondsRemaining / 3600
        let minutes = (secondsRemaining % 3600) / 60
        let seconds = secondsRemaining % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    func tic() {
        guard timerState == .running else { return }
        
        if secondsRemaining > 0 {
            secondsRemaining -= 1
        } else {
            timerState = .finished
            notifications.cancelNotifications()
        }
    }
    
    func resume() {
        timerState = .running
        notifications.scheduleNotification(secondsRemaining: secondsRemaining)
    }
    
    func calculateCompletionPercentage(sessionTotal: Int, goalTotal: Int) -> Int {
        guard goalTotal > 0 else { return 0 }
        
        let minutesRemaining = Double(secondsRemaining) / Double(60)
        let completedTime = Double(sessionTotal) - minutesRemaining
        let rawPercentage = completedTime / Double(goalTotal)
        let percentage = Int(rawPercentage * 100)
        
        return max(0, min(percentage, 100))
    }
    
    func calculateCompletedTime(sessionTotal: Int) -> Int {
        let minutesRemaining = Double(secondsRemaining) / Double(60)
        let completedTime = Double(sessionTotal) - minutesRemaining
        
        return Int(completedTime)
    }
}
