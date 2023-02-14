//
//  Location.swift
//  BucketList
//
//  Created by Annalie Kruseman on 11/9/22.
//

import CoreLocation
import Foundation

struct Location: Identifiable, Codable, Equatable {
    // make id mutable, because otherwise the ID won't be updated and therefore the map doesn't get updated
    var id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // add an example location
    static let example = Location(id: UUID(), name: "Buckingham Palace", description: "Where Queen Elizabeth lives with her dorgis.", latitude: 51.501, longitude: -0.141)

    // write a comparison function to make sure locations are unique (according to the Identifiable and Equatable protocols)
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
