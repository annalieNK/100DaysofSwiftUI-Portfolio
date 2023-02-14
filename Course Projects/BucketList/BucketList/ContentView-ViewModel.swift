//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Annalie Kruseman on 11/9/22.
//

import Foundation
import LocalAuthentication
import MapKit

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        // insert the @State private vars from ContentView
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        @Published private(set) var locations: [Location]
        @Published var selectedPlace: Location?
        @Published var isUnlocked = false
        
        @Published var authenticationError = "Something went wrong"
        @Published var isShowingAuthenticationError = false
                
        // store the location we're saving to
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")

        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        // encrypting the data using .completeFileProtection
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func addLocation() {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            guard let selectedPlace = selectedPlace else { return }

            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    // run the task on the main actor
                    Task { @MainActor in
                        if success {
                            self.isUnlocked = true
                        } else {
                            self.authenticationError = "We need your authentication to continue, please try again."
                            self.isShowingAuthenticationError = true
                        }
                    }
                }
            } else {
                // no biometrics
                authenticationError = "Your phone does not support authentication."
                isShowingAuthenticationError = true
            }
        }
    }
}
