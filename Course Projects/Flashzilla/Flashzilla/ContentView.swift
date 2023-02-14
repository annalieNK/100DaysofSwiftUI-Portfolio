//
//  ContentView.swift
//  Flashzilla
//
//  Created by Annalie Kruseman on 1/23/23.
//

import SwiftUI

// create a card stack where each card is a little further down the screen than the ones before it
extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 10)
    }
}

struct ContentView: View {
    // activate accessibility environment for color blindness
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    // activated voice over environment
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    
    // create an array of repeating cards
    // @State private var cards = [Card](repeating: Card.example, count: 10)
    // create an empty array of cards
    // @State private var cards = [Card]()
    
    // use DataManager to load the card deck
    @State private var cards = DataManager.load()
  
    // add a timer
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // correct for loss of seconds when app moves to the background
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    // add a variable to edit cards
    @State private var showingEditScreen = false
    
    var body: some View {
        ZStack {
            // ignore reading the background image when using VoiceOver
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                // add a timer view (this actually results in a difference of 3 seconds when moving the app to the backgound and back)
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                
                ZStack {
//                    ForEach(0..<cards.count, id: \.self) { index in
                    // correct for the mutable index
                    ForEach(cards) { card in
                        // set a unique index of the card
                        let index = cards.firstIndex(of: card)!
                        
                        CardView(card: cards[index]) { reinsert in
                            // remove card
                            withAnimation {
                                removeCard(at: index, reinsert: reinsert)
                            }
                        }
                        .stacked(at: index, in: cards.count)
                        // disallow tapping on all other cards than the first
                        .allowsHitTesting(index == cards.count - 1)
                        // ignore voice over for the background image and all other cards
                        .accessibilityHidden(index < cards.count - 1)
                    }
                }
                // disable tapping when user has run out of time
                .allowsHitTesting(timeRemaining > 0)
                
                // if card array is empty start again
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundColor(.black)
                        .clipShape(Capsule())
                }
            }
            
            // create a button to add new cards
            VStack {
                HStack {
                    Spacer()

                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                }

                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            // if either of these conditions are true, then make it buttons instead of gestures
            if differentiateWithoutColor || voiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1, reinsert: true)
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")

                        Spacer()

                        Button {
                            withAnimation {
                                removeCard(at: cards.count - 1, reinsert: false)
                            }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct.")
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        // add timer
        .onReceive(timer) { time in
            // only correct timer when app moves to the background
            guard isActive else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        // detect when app moves to the background
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                // continue with timer when cards array is not empty and when moving back to the app
                if cards.isEmpty == false {
                    isActive = true
                }
            } else {
                isActive = false
            }
        }
        // add cards, add a function when the sheet is dismissed with onDismiss
        // adding a View.init can only be done when there are no initializers
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: EditCards.init) //{
//            EditCards()
//        }
        // reset cards when screen appears
        .onAppear(perform: resetCards)
    }
    
    // moved to DataManager
//    func loadData() {
//        if let data = UserDefaults.standard.data(forKey: "Cards") {
//            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
//                cards = decoded
//            }
//        }
//    }
    
    // reinsert card when incorrect
    func removeCard(at index: Int, reinsert: Bool) {
        // don't remove a card that doesn't exist
        guard index >= 0 else { return }
        
        // reinsert card to the back
        if reinsert {
            cards.move(fromOffsets: IndexSet(integer: index), toOffset: 0)
        } else {
            cards.remove(at: index)
        }
        
        // but only if card array is not empty
        if cards.isEmpty {
            isActive = true
        }
    }
    
    // reset cards
    func resetCards() {
        // cards = [Card](repeating: Card.example, count: 10)
        timeRemaining = 100
        isActive = true
        
        // loading the cards moved to DataManager
        // loadData()
        cards = DataManager.load()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
