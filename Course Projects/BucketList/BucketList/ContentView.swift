//
//  ContentView.swift
//  BucketList
//
//  Created by Annalie Kruseman on 11/8/22.
//

import MapKit
import SwiftUI

struct ContentView: View {
    // replace @State private vars with the ViewModel class
    @StateObject private var viewModel = ViewModel()
        
    var body: some View {
        if viewModel.isUnlocked {
            ZStack {
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        VStack {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundColor(.red)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(Circle())
                            
                            Text(location.name)
                                .fixedSize()
                        }
                        .onTapGesture {
                            viewModel.selectedPlace = location
                        }
                    }
                }
                .ignoresSafeArea()
                Circle()
                    .fill(.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            // create a new location, referring to the ContentView extension
                            viewModel.addLocation()
                        } label: {
                            Image(systemName: "plus")
                                .padding()
                                .background(.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding(.trailing)
                        }
                    }
                }
            }
            .sheet(item: $viewModel.selectedPlace) { place in
                // replace with the updated location from the ContenView extension
                EditView(location: place) {
                    viewModel.update(location: $0)
                }
            }
        } else {
            Button("Unlock places") {
                viewModel.authenticate()
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            .alert("Authentication Error", isPresented: $viewModel.isShowingAuthenticationError) {
                Button("OK") { }
            } message: {
                Text(viewModel.authenticationError)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
