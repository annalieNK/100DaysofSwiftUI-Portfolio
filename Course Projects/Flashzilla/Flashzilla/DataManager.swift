//
//  DataManager.swift
//  Flashzilla
//
//  Created by Annalie Kruseman on 1/25/23.
//

import Foundation

// handle loading and saving centrally
struct DataManager {
    static let savePath = FileManager.documentsDirectory.appendingPathComponent("SaveData")

    static func load() -> [Card] {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                return decoded
            }
        }

        return []
    }

    static func save(_ cards: [Card]) {
        if let data = try? JSONEncoder().encode(cards) {
            try? data.write(to: savePath, options: [.atomic, .completeFileProtection])
        }
    }
}
