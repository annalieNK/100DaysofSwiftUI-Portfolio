//
//  View-ExpenseStyling.swift
//  iExpense
//
//  Created by Annalie Kruseman on 9/27/22.
//

import SwiftUI

extension View {
    func style(for item: ExpenseItem) -> some View {
        if item.amount < 10 {
            return self.foregroundColor(.green)
        } else if (item.amount < 100) {
            return self.foregroundColor(.blue)
        } else {
            return self.foregroundColor(.red)
        }
    }
}
