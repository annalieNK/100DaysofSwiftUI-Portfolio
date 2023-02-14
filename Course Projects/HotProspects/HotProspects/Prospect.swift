//
//  Prospect.swift
//  HotProspects
//
//  Created by Annalie Kruseman on 1/17/23.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    // prevent this property to be changed outside this file (through the use of the toggle function)
    fileprivate(set) var isContacted = false
}

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    let savePath = FileManager.documentsDirectory.appendingPathExtension("SavedData")

    // laod the data from UserDefaults
    init() {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                people = decoded
                return
            }
        }

        // no saved data
        people = []
    }
    
    // save new/changed data to UserDefaults
    // use private to only allow the save() method be used as part of this class
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            try? encoded.write(to: savePath, options: [.atomic, .completeFileProtection])
        }
    }
    
    // create a separate 'add' method to add new persons to the array
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    // move one person from a View into another View
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
}
