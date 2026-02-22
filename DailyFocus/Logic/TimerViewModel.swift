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
    
    /// Calculates the raw time in seconds and splits it into hours, minutes and seconds. Also does the formatting for CountDownTimer.
    /// > Note: Hours are not displayed if hours = 0.
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
    
    /// Manages the ticking of the timer and ends the timer when secondsRemaining <= 0.
    func tic() {
        guard timerState == .running else { return }
        
        if secondsRemaining > 0 {
            secondsRemaining -= 1
        } else {
            timerState = .finished
            notifications.cancelNotifications()
        }
    }
    
    /// Allows the user to resume the timer properly.
    /// > Note: This also updates the notification scheduling so it doesn't misalign when you pause.
    func resume() {
        timerState = .running
        notifications.scheduleNotification(secondsRemaining: secondsRemaining)
    }
    
    
    /// Calculates the percentage of the task a user has completed after finishing a timer.
    /// - Parameters:
    ///   - sessionTotal: The total amount of time that the user has been focusing for.
    ///   - goalTotal: The total amount of time stored in a task.
    /// - Returns: An integer representing the percentage completed between 0-100
    ///
    /// ### Mathematical Formula:
    /// ```
    /// percentage = (sessionTotal / goalTotal) * 100
    /// ```
    ///
    /// > Note: If goalTotal is 0 or the calculation results in a number outside of the range, the function clamps the results to a minumum of 0 or a maximum of 100.
    ///
    /// > Warning: Even though the function can handle division by 0, avoid doing so to avoid unexpected results.
    func calculateCompletionPercentage(sessionTotal: Int, goalTotal: Int) -> Int {
        guard goalTotal > 0 else { return 0 }
        
        let minutesRemaining = Double(secondsRemaining) / Double(60)
        let completedTime = Double(sessionTotal) - minutesRemaining
        let rawPercentage = completedTime / Double(goalTotal)
        let percentage = Int(rawPercentage * 100)
        
        return max(0, min(percentage, 100))
    }
    
    
    /// Calculates the completedTime of a timer.
    /// - Parameter sessionTotal: The total amount of time that the user has been focusing for.
    /// - Returns: An integer representing the completed time.
    func calculateCompletedTime(sessionTotal: Int) -> Int {
        let minutesRemaining = Double(secondsRemaining) / Double(60)
        let completedTime = Double(sessionTotal) - minutesRemaining
        
        return Int(completedTime)
    }
}
