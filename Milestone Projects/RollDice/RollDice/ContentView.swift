//
//  ContentView.swift
//  RollDice
//
//  Created by Annalie Kruseman on 1/26/23.
//

import SwiftUI

extension Color {
    static func random() -> Color {
        return Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1))
    }
}

struct ContentView: View {
    let diceTypes = [4, 6, 8, 10, 12, 20]
        
    @AppStorage("selectedDiceType") var selectedDiceType = 4
    @AppStorage("numberToRoll") var numberToRoll = 4
    
    // store the results of the dices
    @State private var currentResult = Dice(type: 0, number: 0)
    
    // store a column layout
    let columns: [GridItem] = [
        .init(.adaptive(minimum: 60))
    ]
    
    // set a timer to the animation
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var stoppedDice = 0
    
    // add vibration
    @State private var feedback = UIImpactFeedbackGenerator(style: .rigid)

    // save the results
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedRolls.json")
    @State private var savedResults = [Dice]()
    
    // detect whether VoiceOver is running
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Type of dice", selection: $selectedDiceType) {
                        ForEach(diceTypes, id: \.self) {
                            Text(String($0))
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Stepper("Number of dice: \(numberToRoll)", value: $numberToRoll, in: 1...4)
                    
                    Button("Roll them!", action: rollDice)
                } footer: {
                    LazyVGrid(columns: columns) {
                        ForEach(0..<currentResult.rolls.count, id: \.self) { rollNumber in
//                            GeometryReader { geo in
                                Text(String(currentResult.rolls[rollNumber]))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .aspectRatio(1, contentMode: .fit)
                                    .foregroundColor(.black)
                                    //.background(.white)
                                    // extra: add random colors on each roll
                                    .background(Color.random())
                                    .cornerRadius(10)
                                    .shadow(radius: 3)
                                    .font(.title)
                                    .padding(5)
//                            }
                        }
                    }
                    // group the grid
                    .accessibilityElement()
                    .accessibilityLabel("Latest roll: \(currentResult.description)") //.rolls.map(String.init).joined(separator: ", ")
                }
                .disabled(stoppedDice < currentResult.rolls.count)
                
                if savedResults.isEmpty == false {
                    Section("Previous results") {
                        ForEach(savedResults) { result in
                            VStack(alignment: .leading) {
                                Text("\(result.number) x \(result.type)")
                                    .font(.headline)
                                Text(result.description) //.rolls.map(String.init).joined(separator: ", ")
                            }
                            // group the previous results for easier reading with VoiceOver
                            .accessibilityElement()
                            .accessibilityLabel("\(result.number) D\(result.type), \(result.rolls.map(String.init).joined(separator: ", "))")
                        }
                    }
                }
            }
            .navigationTitle("High Rollers")
            .onReceive(timer) { date in
                updateDice()
            }
            .onAppear(perform: load)
        }
    }

    func rollDice() {
        currentResult = Dice(type: selectedDiceType, number: numberToRoll)
        
        // ignore animation when voice over is enabled
        if voiceOverEnabled {
            stoppedDice = numberToRoll
            savedResults.insert(currentResult, at: 0)
            save()
        } else {
            stoppedDice = -20
        }
    }
    
    func updateDice() {
        guard stoppedDice < currentResult.rolls.count else { return }

        for i in stoppedDice..<numberToRoll {
            if i < 0 { continue }
            currentResult.rolls[i] = Int.random(in: 1...selectedDiceType)
//            currentResult.colors[i] = colors.randomElement()
            feedback.impactOccurred()
        }

        stoppedDice += 1
        
        if stoppedDice == numberToRoll {
            savedResults.insert(currentResult, at: 0)
            save()
        }
    }
    
    func load() {
        if let data = try? Data(contentsOf: savePath) {
            if let results = try? JSONDecoder().decode([Dice].self, from: data) {
                savedResults = results
            }
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(savedResults) {
            try? data.write(to: savePath, options: [.atomic, .completeFileProtection])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
