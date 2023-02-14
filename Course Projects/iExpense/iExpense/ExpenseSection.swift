//
//  ExpenseSection.swift
//  iExpense
//
//  Created by Annalie Kruseman on 9/27/22.
//

import SwiftUI

struct ExpenseSection: View {
    let title: String
    let expenses: [ExpenseItem]
    let deleteItems: (IndexSet) -> Void

    var body: some View {
        Section(title) {
            // ForEach(expenses.items, id: \.id) { item in
            // If id is uniquely generated with UUID(), id becomes redundant
            ForEach(expenses) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)
                        Text(item.type)
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("\(item.name), \(item.amount.formatted(.currency(code: "USD")))")
                    .accessibilityHint(item.type)

                    Spacer()

                    Text(item.amount, format: .localCurrency)
                        .style(for: item)
                }
            }
            .onDelete(perform: deleteItems)
        }
    }
}

struct ExpenseSection_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseSection(title: "Example Section", expenses: [], deleteItems: { _ in })
    }
}
