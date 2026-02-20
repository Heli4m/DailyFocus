//
//  Config.swift
//  DailyFocus
//
//  Created by Liam Ngo on 18/1/26.
//

import Foundation
import SwiftUI

struct Config {
    struct Colors {
        static let background = Color(red: 28/255, green: 28/255, blue: 30/255, opacity: 1.0)
        static let item = Color(red: 44/255, green: 44/255, blue: 46/255, opacity: 1.0)
        static let accent = Color(red: 10/255, green: 132/255, blue: 255/255, opacity: 1.0)
        static let inactiveAccent = Color(red: 58/255, green: 100/255, blue: 145/255)
        
        static let mediumPriority = Color(red: 255/255, green: 159/255, blue: 10/255)
        static let highPriority = Color(red: 255/255, green: 69/255, blue: 58/255)
        
        static let primaryText = Color(red: 232/255, green: 234/255, blue: 237/255)
        static let secondaryText = Color(red: 154/255, green: 160/255, blue: 166/255)
    }
    
    struct Layout {
        static let addButtonSizeExternal: CGFloat = 82
        static let addButtonSizeInternal: CGFloat = 75
        static let iconButtonSize: CGFloat = 80
        
        static let bgtimePickerWidth: CGFloat = 290
        static let bgtimePickerHeight: CGFloat = 60
        
        static let timePickerIndividualWidth: CGFloat = 65
        static let timePickerIndividualHeight: CGFloat = 70
        
        static let customTimeBoxWidth: CGFloat = 70
        static let customTimeBoxHeight: CGFloat = 60
        
        static let timePickerSliderWidth: CGFloat = 60
        static let timePickerSliderHeight: CGFloat = 40
        
        static let dividerWidth: CGFloat = 3
        static let dividerHeight: CGFloat = 150
        
        static let priorityDotSize: CGFloat = 10
        
        static let mainSmallCornerRadius: CGFloat = 10
        static let mainCornerRadius: CGFloat = 15
        static let mainBigCornerRadius: CGFloat = 20
        
        static let standardSmallTextSize: CGFloat = 18
        static let standardMediumTextSize: CGFloat = 20
        static let standardTitleTextSize: CGFloat = 24
        
        static let standardPaddingSmall: CGFloat = 5
        static let standardPaddingMedium: CGFloat = 10
        static let standardPaddingLarge: CGFloat = 20
        static let standardPaddingExtraLarge: CGFloat = 40
    }
    
    struct Time {
        static let sheetDismissDelay: Double = 0.1
        static let standardTransitionSpeed: Double = 0.3
        static let addButtonSpin: Double = 1440
    }
    
    struct Defaults {
        static let timeSelections: [Int] = [15, 30, 45, 60]
        static let defaultPriority: Int = 1
    }
    
    struct Limits {
        static let taskNameMax: Int = 30
        static let maxHours: Int = 23
        static let maxMinutes: Int = 59
        static let quickStartMax: Int = 15
    }
}

enum AppState: String, Identifiable {
    case editingTask
    case openingTask
    case settingFocusTime
    case timerTab
    case runningTask
    case finishingTask
    
    var id: String { self.rawValue }
}

enum TimerStates {
    case running
    case paused
    case finished
}

enum TabEnum {
    case home
    case timedtasks
    case timer
    case checklist
    case settings
}

