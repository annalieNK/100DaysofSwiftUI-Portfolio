//
//  ContentView-ViewModel.swift
//  PersonLookup
//
//  Created by Annalie Kruseman on 12/7/22.
//

import Foundation
import UIKit

@MainActor class ViewModel: ObservableObject {
    @Published private(set) var person: [Person]
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedLocations")
    
    let locationFetcher = LocationFetcher()
        
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            person = try JSONDecoder().decode([Person].self, from: data)
        } catch {
            person = []
        }
    }
    
    func addNewPerson(name: String, inputUIImage: UIImage?, locationName: String, latitude: Double, longitude: Double) {
        guard let imageData = inputUIImage?.jpegData(compressionQuality: 0.8) else { return }
        let newPerson = Person(name: name, imageData: imageData,locationName: locationName, latitude: latitude, longitude: longitude)
        self.person.append(newPerson)
        saveContact()
    }
    
    func saveContact() {
        do {
            let data = try JSONEncoder().encode(self.person)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            print("Saved contact")
        } catch {
            print("Unable to save data")
        }
    }
    
    func updateView() {
        self.objectWillChange.send()
    }
    
    func removeRows(at offsets: IndexSet) {
        self.person.remove(atOffsets: offsets)
        saveContact()
        print("deleted")
    }
}
