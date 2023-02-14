//
//  EditCards.swift
//  Flashzilla
//
//  Created by Annalie Kruseman on 1/24/23.
//

import SwiftUI

struct EditCards: View {
    @Environment(\.dismiss) var dismiss
    // create an empty cards array
    // @State private var cards = [Card]()
    
    // use DataManager to load the card deck
    @State private var cards = DataManager.load()
    
    @State private var newPrompt = ""
    @State private var newAnswer = ""

    var body: some View {
        NavigationView {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add card", action: addCard)
                }

                Section {
                    ForEach(0..<cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(cards[index].prompt)
                                .font(.headline)
                            Text(cards[index].answer)
                                .foregroundColor(.secondary)
                        }
                    }
                    .onDelete(perform: removeCards)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar {
                Button("Done", action: done)
            }
            .listStyle(.grouped)
//            .onAppear(perform: loadData)
        }
    }

    func done() {
        dismiss()
    }

    // moved to DataManager
//    func loadData() {
//        if let data = UserDefaults.standard.data(forKey: "Cards") {
//            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
//                cards = decoded
//            }
//        }
//    }

//    func saveData() {
//        if let data = try? JSONEncoder().encode(cards) {
//            UserDefaults.standard.set(data, forKey: "Cards")
//        }
//    }

    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }

        let card = Card(prompt: trimmedPrompt, answer: trimmedAnswer)
        // ! insert card in array!
        cards.insert(card, at: 0)
           
        // moved to DataManager
        // saveData()
        DataManager.save(cards)
        
        // clear previous values
        newPrompt = ""
        newAnswer = ""
    }

    func removeCards(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
        
        // moved to DataManager
        // saveData()
        DataManager.save(cards)
    }
}

struct EditCards_Previews: PreviewProvider {
    static var previews: some View {
        EditCards()
    }
}
