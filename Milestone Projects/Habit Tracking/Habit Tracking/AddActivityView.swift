//
//  AddActivityView.swift
//  Habit Tracking
//
//  Created by Annalie Kruseman on 10/5/22.
//

import SwiftUI

struct AddActivityView: View {
    @ObservedObject var habits: Activities
    @State private var title = ""
    @State private var description = ""
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
            }
            .navigationTitle("Add new habit")
            .toolbar {
                Button("Save") {
                    let activity = Activity(title: title, description: description)
                    habits.activities.append(activity)
                    dismiss()
                }
            }
        }
    }
}

struct AddActivityView_Previews: PreviewProvider {
    static var previews: some View {
        AddActivityView(habits: Activities())
    }
}
