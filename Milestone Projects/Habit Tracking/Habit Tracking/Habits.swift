//
//  Habits.swift
//  Habit Tracking
//
//  Created by Annalie Kruseman on 10/5/22.
//

// Store the newly defined habits as an object to refer to

import Foundation

class Activities: ObservableObject {
    @Published var activities = [Activity]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(activities) {
                UserDefaults.standard.set(encoded, forKey: "Activity")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Activity") {
            if let decodedItems = try? JSONDecoder().decode([Activity].self, from: savedItems) {
                activities = decodedItems
                return
            }
        }

        activities = []
    }
}
