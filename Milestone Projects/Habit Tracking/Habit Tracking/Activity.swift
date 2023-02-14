//
//  HabitActivity.swift
//  Habit Tracking
//
//  Created by Annalie Kruseman on 10/5/22.
//

// Create the type of a new activity

import Foundation

struct Activity: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var description: String
    var completionCount = 0
    
    static let example = Activity(title: "Example activity", description: "This is a test activity.")
}
