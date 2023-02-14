//
//  ExpenseItem.swift
//  iExpense
//
//  Created by Annalie Kruseman on 9/26/22.
//

import Foundation

struct ExpenseItem: Identifiable, Codable, Equatable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
