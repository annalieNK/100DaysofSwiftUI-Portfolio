//
//  Resort.swift
//  SnowSeeker
//
//  Created by Annalie Kruseman on 2/6/23.
//

import Foundation

struct Resort: Codable, Identifiable {
    let id: String
    let name: String
    let country: String
    let description: String
    let imageCredit: String
    let price: Int
    let size: Int
    let snowDepth: Int
    let elevation: Int
    let runs: Int
    let facilities: [String]
    
    // add the new Facility struct as a variable
    var facilityTypes: [Facility] {
        // map each facility to its name
        facilities.map(Facility.init)
    }
    
    static let allResorts: [Resort] = Bundle.main.decode("resorts.json")
    static let example = allResorts[0]
    // static let example = (Bundle.main.decode("resorts.json) as [Resort])[0]
}