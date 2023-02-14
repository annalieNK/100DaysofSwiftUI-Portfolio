//
//  ContentView.swift
//  Shared
//
//  Created by Annalie Kruseman on 9/13/22.


import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var letterScore = 0
    //    @State private var wordScore = 0
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter text here", text: $newWord)
                        .autocapitalization(.none)
                }
                
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle.fill")
                            Text(word)
                        }
                        .accessibilityElement(children: .ignore)
//                        .accessibilityLabel("\(word), \(word.count) letters")
                        .accessibilityLabel(word)
                        .accessibilityHint("\(word.count) letters")
                    }
                }
                
                //                Section {
                //                    Text("Score: \(letterScore * wordScore)")
                //                }
            }
            .navigationTitle(rootWord)
            .toolbar {
                Button("Restart", action: startGame)
            }
        }
        .onSubmit(addNewWord)
        .onAppear(perform: startGame)
        .alert(errorTitle, isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .safeAreaInset(edge: .bottom) {
            Text("Score: \(letterScore)")
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .font(.title)
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count >= 3 else {
            wordError(title: "Word not long enough", message: "Word needs to be of at least three letters" )
            return
        }
        
        guard isRootWord(word: answer) else {
            wordError(title: "Same as root word", message: "Use a unique word")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Try another word")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "Use only letters that are presented")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word does not exist", message: "Use only words that are real words")
            return
        }
        
        withAnimation {
            usedWords.insert(answer, at: 0)
        }
        newWord = ""
        letterScore += answer.count
        //        wordScore = usedWords.count
    }
    
    func startGame() {
        newWord = ""
        letterScore = 0
        //        wordScore = 0
        usedWords.removeAll()
        
        // 1. Find the URL for start.txt in our app bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // 2. Load start.txt into a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                // 3. Split the string up into an array of strings, splitting on line breaks
                let allWords = startWords.components(separatedBy: "\n")
                
                // 4. Pick one random word, or use "silkworm" as a sensible default
                rootWord = allWords.randomElement() ?? "silkworm"
                
                // If we are here everything has worked, so we can exit
                return
            }
        }
        
        // If were are *here* then there was a problem – trigger a crash and report the error
        fatalError("Could not load start.txt from bundle.")
    }
    
    func wordCount() {
        
    }
    
    func isRootWord(word: String) -> Bool {
        word != rootWord
    }
    
    // Check if the word has not already been used in the list of usedWords -> continue
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    // Check if the letters of the chosen word are in the actual rootWord and remove the corresponding letters in rootWord
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let idx = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: idx)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
