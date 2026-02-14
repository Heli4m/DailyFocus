//
//  AppStates.swift
//  DailyFocus
//
//  Created by Liam Ngo on 30/1/26.
//

import Foundation

// enum for all of the states of the app
enum AppState: String, Identifiable {
    case editingTask
    case openingTask
    case settingFocusTime
    case timerTab
    case runningTask
    case finishingTask
    
    var id: String { self.rawValue }
}
