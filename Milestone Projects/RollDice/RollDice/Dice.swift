//
//  Dice.swift
//  RollDice
//
//  Created by Annalie Kruseman on 1/26/23.
//

import Foundation

struct Dice: Identifiable, Codable {
    var id = UUID()
    var type: Int
    var number: Int
    var rolls = [Int]()
    
    var description: String {
        rolls.map(String.init).joined(separator: ", ")
    }

    init(type: Int, number: Int) {
        self.type = type
        self.number = number

        // roll the dice
        for _ in 0..<number {
            let roll = Int.random(in: 1...type)
            rolls.append(roll)
        }
    }
}
