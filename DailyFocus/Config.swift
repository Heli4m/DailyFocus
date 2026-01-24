//
//  Config.swift
//  DailyFocus
//
//  Created by Liam Ngo on 18/1/26.
//

import Foundation
import SwiftUI

struct Config {
    // design
    static let bgColor = Color(red: 28/255, green: 28/255, blue: 30/255, opacity: 1.0)
    static let itemColor = Color(red: 44/255, green: 44/255, blue: 46/255, opacity: 1.0)
    static let accentColor = Color(red: 10/255, green: 132/255, blue: 255/255, opacity: 1.0)
    static let inactiveAccentColor = Color(red: 58/255, green: 100/255, blue: 145/255)
    
    // priority colors
    static let mediumPriority = Color(red: 255/255, green: 159/255, blue: 10/255)
    static let highPriority = Color(red: 255/255, green: 69/255, blue: 58/255)
        
    // text colors
    static let primaryText = Color(red: 232/255, green: 234/255, blue: 237/255)
    static let secondaryText = Color(red: 154/255, green: 160/255, blue: 166/255)
}

// stores data for each tasks
struct TaskData: Identifiable {
    let id = UUID()
    let name: String
    let time: Int
    let priority: Int
}

// enum for all of the states of the app
enum AppState: String, Identifiable {
    case editingTask
    case openingTask
    
    var id: String { self.rawValue }
}
