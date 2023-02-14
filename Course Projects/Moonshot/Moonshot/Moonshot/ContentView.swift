//
//  ContentView.swift
//  Moonshot
//
//  Created by Annalie Kruseman on 9/28/22.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
//    @State private var showingGrid = true
    @AppStorage("showingGrid") private var showingGrid = true
    
    var body: some View {
        NavigationView {
            // modifiers can only be applied to a View, not a condition, so add a View
            Group {
                if showingGrid {
                    GridLayout(astronauts: astronauts, missions: missions)
                } else {
                    ListLayout(astronauts: astronauts, missions: missions)
                }
            }
            .toolbar {
                Button {
                    showingGrid.toggle()
                } label: {
                    if showingGrid {
                        Label("Show table", systemImage: "list.dash")
                    } else {
                        Label("Show grid", systemImage: "square.grid.2x2")
                    }
                }
            }
            .navigationTitle("Moonshot")
            .background(.darkBackground)
            // set to dark mode 
            .preferredColorScheme(.dark)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
