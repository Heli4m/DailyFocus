//
//  Persistence.swift
//  DailyFocus
//
//  Created by Liam Ngo on 28/1/26.
//

import Foundation

func saveData(data: [TaskData]) {
    do {
        let JSONData = try JSONEncoder().encode(data) // encodes data
        UserDefaults.standard.set(JSONData, forKey: "SavedTasks") // stores it in UserDefaults (on phone) with the key SavedTasks
        print("Successfully saved tasks")
    } catch {
        print("Error loading data into JSON")
    }
}

func loadData() -> [TaskData] {
    guard let JSONData = UserDefaults.standard.data(forKey: "SavedTasks") else { // takes data from UserDefaults and puts it in a variable
        return []
    }
    
    do {
        let data = try JSONDecoder().decode([TaskData].self, from: JSONData) // decodes data
        return data
    } catch {
        print("Error decoding JSON")
        return []
    }
}
