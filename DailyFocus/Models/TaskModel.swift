//
//  TaskModel.swift
//  DailyFocus
//
//  Created by Liam Ngo on 18/2/26.
//

import Foundation
import SwiftUI

struct TaskData: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let time: Int
    let priority: Int
    
    var priorityColor: Color {
        switch self.priority {
        case 3:
            return Config.highPriority
        case 2:
            return Config.mediumPriority
        default:
            return Config.accentColor
        }
    }
    
    init(id: UUID = UUID(), name: String, time: Int, priority: Int) {
        self.id = id
        self.name = name
        self.time = time
        self.priority = priority
    }
}
