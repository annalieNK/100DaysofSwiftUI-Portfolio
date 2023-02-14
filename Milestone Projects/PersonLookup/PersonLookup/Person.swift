//
//  Person.swift
//  PersonLookup
//
//  Created by Annalie Kruseman on 12/7/22.
//

//
//  Person.swift
//  PersonLookup
//
//  Created by Annalie Kruseman on 12/7/22.
//

import Foundation
import UIKit
import SwiftUI
import MapKit

struct Person: Codable, Identifiable, Equatable, Comparable {
    var id: UUID
    var name: String
    var imageData: Data
    
    var locationName: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
            CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }

    init(name: String, imageData: Data, locationName: String, latitude: Double, longitude: Double) {
        self.id = UUID()
        self.name = name
        self.imageData = imageData
        
        self.locationName = locationName
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func convertDataToImage() -> Image {
        let uiImageData = imageData
        if let uiImage = UIImage(data: uiImageData) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "person.crop.circle")
        }
    }
    
//    static let example = Person(id: UUID(), name: "Annalie", imageData: UIImage(systemName: "person.crop.square")?.jpegData(compressionQuality: 1) ?? Data())
    static let example = Person(name: "Annalie", imageData: UIImage(named: "Steve_Jobs")?.jpegData(compressionQuality: 1) ?? Data(),locationName: "Daycare", latitude: 37.773972, longitude: -122.431297)

    static func ==(lhs: Person, rhs: Person) -> Bool {
        lhs.id == rhs.id
    }
    
    static func <(lhs: Person, rhs: Person) -> Bool {
        lhs.name < rhs.name
    }
}
