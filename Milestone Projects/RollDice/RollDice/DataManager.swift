//
//  DataManager.swift
//  RollDice
//
//  Created by Annalie Kruseman on 1/30/23.
//

import Foundation

// handle loading and saving centrally
struct DataManager {
    static let savePath = FileManager.documentsDirectory.appendingPathComponent("SaveData")

    static func load() -> [Dice] {
        if let data = try? Data(contentsOf: savePath) {
            if let decoded = try? JSONDecoder().decode([Dice].self, from: data) {
                return decoded
            }
        }

        return []
    }

    static func save(_ dices: [Dice]) {
        if let data = try? JSONEncoder().encode(dices) {
            try? data.write(to: savePath, options: [.atomic, .completeFileProtection])
        }
    }
}
