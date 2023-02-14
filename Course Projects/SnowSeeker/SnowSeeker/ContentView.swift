//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Annalie Kruseman on 2/1/23.
//

import SwiftUI

// extension builds the same layout for each phone, regardless of size
extension View {
    @ViewBuilder func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationViewStyle(.stack)
        } else {
            self
        }
    }
}

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    // sort resorts by name or country (name is default based on order of adding)
    enum SortType {
        case `default`, name, country
    }
    
    // track favorites
    @StateObject var favorites = Favorites()
    
    @State private var searchText = ""
    
    // add sort order in ConfirmationDialog
    @State private var sortType = SortType.default
    @State private var showinSortOptions = false
    
    var body: some View {
        NavigationView {
            List(sortedResorts) { resort in //after adding a sort use sorted instead of filteredResorts
                NavigationLink {
                    ResortView(resort: resort)
                } label: {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 5)
                            )
                            // add an overlay to create a border around the flags
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundColor(.secondary)
                        }
                        
                        // add a heart to show favorite
                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            // add search bar
            .searchable(text: $searchText, prompt: "Search for a resort")
            // add a place to activate the sort options
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showinSortOptions = true
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
            // add sort ConfirmationDialog
            .confirmationDialog("Sort resorts", isPresented: $showinSortOptions) {
                Button("Default") { sortType = .default }
                Button("Name (A-Z)") { sortType = .name }
                Button("Country (A-Z)") { sortType = .country }
                // Button("Cancel", role: .cancel) { }
            } message: {
                Text("Select order to sort resorts")
            }
            
            // a second view is only visible in iphones and ipads that are large enough
            WelcomeView()
        }
        // build the same layout for each phone
        //.phoneOnlyStackNavigationView()
        
        // provide all the views access to the favorites variable
        .environmentObject(favorites)
    }
    
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            return resorts
        } else {
            return resorts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    // apply the sort to filteredResorts
    var sortedResorts: [Resort] {
        switch sortType {
        case .default:
            return filteredResorts
        case .name:
            return filteredResorts.sorted { $0.name < $1.name }
        case .country:
            return filteredResorts.sorted { $0.country < $1.country }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
