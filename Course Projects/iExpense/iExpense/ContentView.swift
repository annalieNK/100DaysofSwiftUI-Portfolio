//
//  ContentView.swift
//  iExpense
//
//  Created by Annalie Kruseman on 9/26/22.
//

import SwiftUI

//struct ExpenseItem: Identifiable {
//    let id = UUID()
//    let name: String
//    let type: String
//    let amount: Double
//}

//
//class Expenses: ObservableObject {
//    @Published var items = [ExpenseItem]()
//}

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    //    let localCurrency: FloatingPointFormatStyle<Double>.Currency = .currency(code: Locale.current.currency?.identifier ?? "USD")
    
    var body: some View {
        NavigationView {
            List {
                ExpenseSection(title: "Pesonal", expenses: expenses.personalItems, deleteItems: removePersonalItems)
                
                ExpenseSection(title: "Business", expenses: expenses.businessItems, deleteItems: removeBusinessItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    //                    let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
                    //                    expenses.items.append(expense)
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
        }
    }
    
//    func removeItems(at offsets: IndexSet) {
//        expenses.items.remove(atOffsets: offsets)
//    }
    func removeItems(at offsets: IndexSet, in inputArray: [ExpenseItem]) {
        var objectsToDelete = IndexSet()

        for offset in offsets {
            let item = inputArray[offset]

            if let index = expenses.items.firstIndex(of: item) {
                objectsToDelete.insert(index)
            }
        }

        expenses.items.remove(atOffsets: objectsToDelete)
    }
    
    func removePersonalItems(at offsets: IndexSet) {
        removeItems(at: offsets, in: expenses.personalItems)
    }

    func removeBusinessItems(at offsets: IndexSet) {
        removeItems(at: offsets, in: expenses.businessItems)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
