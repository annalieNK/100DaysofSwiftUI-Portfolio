//
//  ContentView.swift
//  HotProspects
//
//  Created by Annalie Kruseman on 1/11/23.
//

import SwiftUI

struct ContentView: View {
    // we want all our ProspectsView instances to share a single instance of the Prospects class, so they are all pointing to the same data
    // 1. create and store a single instance of the Prospect class
    @StateObject var prospects = Prospects()
    
    var body: some View {
        TabView {
            ProspectsView(filter: .none)
                .tabItem {
                    Label("Everyone", systemImage: "person.3")
                }
            ProspectsView(filter: .contacted)
                .tabItem {
                    Label("Contacted", systemImage: "checkmark.circle")
                }
            ProspectsView(filter: .uncontacted)
                .tabItem {
                    Label("Uncontacted", systemImage: "questionmark.diamond")
                }
            MeView()
                .tabItem {
                    Label("Me", systemImage: "person.crop.square")
                }
        }
        // 2. Add the prospects object to all views inside TabView
        // Add the same class to ProspectsView Preview
        .environmentObject(prospects)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

