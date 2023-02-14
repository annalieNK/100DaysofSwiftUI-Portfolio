//
//  ContentView.swift
//  Shared
//
//  Created by Annalie Kruseman on 9/7/22.
//

import SwiftUI

//struct FlagImage: View {
//    let name: String
//    @State private var selectedFlag = -1
//
//    var body: some View {
//        Image(name)
//            .renderingMode(.original)
//            .clipShape(Capsule())
//            .shadow(radius: 5)
//            .rotation3DEffect(.degrees(selectedFlag == name ? 360 : 0), axis: (x: 0, y: 1, z: 0))
//    }
//}

struct ContentView: View {
    @State private var questionCounter = 1
    @State private var showingScore = false
    @State private var showingResult = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var countries = allCountries.shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    let labels = [
            "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
            "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
            "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
            "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
            "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
            "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
            "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
            "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
            "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
            "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
            "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
        ]
    
    @State private var selectedFlag = -1
    
    static let allCountries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"]
    

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            //            LinearGradient(gradient: Gradient(colors: [.mint, .black]), startPoint: .top, endPoint: .bottom)
            //            Color.mint
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                        //                            .foregroundColor(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
//                            FlagImage(name: countries[number])
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                                .rotation3DEffect(.degrees(selectedFlag == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                                // blur the flag if it is not the tapped flag
                                .opacity(selectedFlag == -1 || selectedFlag == number ? 1 : 0.25)
                                .scaleEffect(selectedFlag == -1 || selectedFlag == number ? 1 : 0.5)
                                .animation(.default, value: selectedFlag)
                                .accessibilityLabel(labels[countries[number], default: "unknown flag"])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Game finished!", isPresented: $showingResult) {
            Button("Start again", action: newGame)
        } message: {
            Text("Your total score is \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        selectedFlag = number
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            let theCountries = ["UK", "US"]
            let theirAnswer = countries[number]

            if theCountries.contains(theirAnswer) {
                scoreTitle = "Wrong that's the flag of the \(theirAnswer)"
            } else {
                scoreTitle = "Wrong that's the flag of \(theirAnswer)"
            }

            if score > 0 {
                score -= 1
            }
        }
        
        if questionCounter == 8 {
            showingResult = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.remove(at: correctAnswer)
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionCounter += 1
        selectedFlag = -1
    }
    
    func newGame() {
        questionCounter = 0
        score = 0
        countries = Self.allCountries
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
