//
//  PersonOriginal.swift
//  PersonLookup
//
//  Created by Annalie Kruseman on 12/8/22.
//

import Foundation
import UIKit
import SwiftUI

struct PersonOriginal: Codable, Identifiable, Equatable {
    var id: UUID
    var name: String
    var imageData: Data
    
    init(name: String, imageData: Data) {
        self.id = UUID()
        self.name = name
        self.imageData = imageData
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
    static let example = PersonOriginal(name: "Steve Jobs", imageData: UIImage(named: "Steve_Jobs")?.jpegData(compressionQuality: 1) ?? Data())

    static func ==(lhs: PersonOriginal, rhs: PersonOriginal) -> Bool {
        lhs.id == rhs.id
    }
    
    static func <(lhs: PersonOriginal, rhs: PersonOriginal) -> Bool {
        lhs.name < rhs.name
    }
}
