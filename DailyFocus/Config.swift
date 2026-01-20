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
    static let bgColor = Color(red: 47/255, green: 47/255, blue: 47/255, opacity: 1.0)
    static let primaryText = Color(red: 232/255, green: 234/255, blue: 237/255)
    static let itemColor = Color(red: 154/255, green: 160/255, blue: 166/255)
}

enum AppState {
    case editingTask
    
    var id: Self { self }
}
