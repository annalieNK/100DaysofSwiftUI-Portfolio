//
//  ContentView.swift
//  PersonLookup
//
//  Created by Annalie Kruseman on 12/7/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var viewModel = ViewModel()

    @State private var showingAddPerson = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.person) { person in
                    NavigationLink {
                        DetailView(person: person, mapRegion: MKCoordinateRegion())
                    } label: {
                        PersonListView(person: person)
                            .padding(-10)
                    }
                }
                .onDelete { index in
                    viewModel.removeRows(at: index)
                }
            }
            .navigationTitle("Favorite Places")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddPerson = true
                    } label: {
                        Label("Add Place", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddPerson) {
                AddPersonView(person: Person.example)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
