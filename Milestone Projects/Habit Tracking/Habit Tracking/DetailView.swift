//
//  DetailView.swift
//  Habit Tracking
//
//  Created by Annalie Kruseman on 10/5/22.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var habits: Activities
    var activity: Activity
    
    var body: some View {
//        VStack {
        List {
            Section {
                if activity.description.isEmpty == false {
                    Text(activity.description)
                }
            }
            
            Section {
                Button("Completed!") {
                    // Refer to the activity that is clicked on
                    var newActivity = activity
                    newActivity.completionCount += 1
                    
                    if let index = habits.activities.firstIndex(of: activity) {
                        habits.activities[index] = newActivity
                    }
                }
                
                Text("Completion count: \(activity.completionCount)")
            }
        }
        .navigationTitle(activity.title)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(habits: Activities(), activity: Activity.example)
    }
}
