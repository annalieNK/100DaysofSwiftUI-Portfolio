//
//  CompletionStyling.swift
//  Habit Tracking
//
//  Created by Annalie Kruseman on 10/6/22.
//

import SwiftUI

extension View {
    func color(for activity: Activity) -> Color {
        if activity.completionCount < 3 {
            return .red
        } else if activity.completionCount < 10 {
            return .orange
        } else if activity.completionCount < 20 {
            return .green
        } else if activity.completionCount < 50 {
            return .blue
        } else {
            return .indigo
        }
    }
}


