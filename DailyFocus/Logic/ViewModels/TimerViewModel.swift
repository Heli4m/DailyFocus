//
//  TimerViewModel.swift
//  DailyFocus
//
//  Created by Liam Ngo on 30/1/26.
//

import Foundation
import SwiftUI
import UserNotifications

@Observable
class TimerViewModel {
    var secondsRemaining: Int
    let totalSeconds: Int
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
}
