//
//  ContentView.swift
//  Shared
//
//  Created by Annalie Kruseman on 9/8/22.
//
// Challenge: make a brain training game that challenges players to win or lose at rock, paper, scissors.
//1. Each turn of the game the app will randomly pick either rock, paper, or scissors.
//2. Each turn the app will alternate between prompting the player to win or lose.
//3. The player must then tap the correct move to win or lose the game.
//4. If they are correct they score a point; otherwise they lose a point.
//5. The game ends after 10 questions, at which point their score is shown.

import SwiftUI

struct AppChoice {
    let gameChoices = ["👊", "👋", "✌️"]

    var appChoice = Int.random(in: 0..<3)
}

struct ContentView: View {
    
    let gameChoices = ["👊", "👋", "✌️"]
    
    @State private var questionCounter = 1
    @State private var showingResult = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    @State private var appChoice = Int.random(in: 0..<3)
    @State private var playerWin = Bool.random()
    
    var body: some View {
        VStack {
            Text("Rock - Paper - Scissors")
                .font(.largeTitle)
                .foregroundColor(.orange)
            
            Spacer()
            
            // return random appChoice
            Text("App has played:")
                .font(.title)
            Text(gameChoices[appChoice])
                .font(.system(size: 200))
            
            Spacer()
            
            // return either win or loose
            if playerWin {
                Text("Which one wins?")
                    .font(.title2)
                    .foregroundColor(.green)
            } else {
                Text("Which one looses?")
                    .font(.title)
                    .foregroundColor(.red)
            }
                        
            HStack {
                ForEach(0..<3) { number in
                    Button(gameChoices[number]) {
                        play(choice: number)
                    }
                    .font(.system(size: 80))
                }
            }
            
            Spacer()
            
            Text("Score: \(score)")
                .font(.title)
            
            Spacer()
            
        }
        .alert("Game is finished!", isPresented: $showingResult) {
            Button("Play again", action: reset)
        } message: {
            Text("Your score was: \(score)")
        }
    }
    
    func play(choice: Int) {
        let winningMoves = [1, 2, 0]
        let didWin: Bool
        
        if playerWin {
            didWin = choice == winningMoves[appChoice]
        } else {
            didWin = winningMoves[choice] == appChoice
        }
        
        if didWin {
            score += 1
        } else {
            score -= 1
        }
        
        if questionCounter == 10 {
            showingResult = true
        } else {
            appChoice = Int.random(in: 0..<3)
            playerWin.toggle()
            questionCounter += 1
        }
    }
    
    func reset() {
        appChoice = Int.random(in: 0..<3)
        playerWin = Bool.random()
        questionCounter = 0
        score = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

