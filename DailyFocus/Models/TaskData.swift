//
//  TaskData.swift
//  DailyFocus
//
//  Created by Liam Ngo on 30/1/26.
//

import Foundation

// stores data for each tasks
struct TaskData: Identifiable, Codable, Equatable {
    let id: UUID
    let name: String
    let time: Int
    let priority: Int
    
    init(id: UUID = UUID(), name: String, time: Int, priority: Int) {
        self.id = id
        self.name = name
        self.time = time
        self.priority = priority
    }
}
