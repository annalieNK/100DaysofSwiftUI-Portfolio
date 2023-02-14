//
//  Bundle-Decodable.swift
//  Moonshot
//
//  Created by Annalie Kruseman on 9/28/22.
//

import Foundation

extension Bundle {
//    func decode(_ file: String) -> [String: Astronaut] {
//    func decode<T>(_ file: String) -> T {
    func decode<T: Codable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()
        
        // format dates
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-dd"
//        formatter.timeZone
        decoder.dateDecodingStrategy = .formatted(formatter)

//        guard let loaded = try? decoder.decode([String: Astronaut].self, from: data) else {
        guard let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }

        return loaded
    }
}

