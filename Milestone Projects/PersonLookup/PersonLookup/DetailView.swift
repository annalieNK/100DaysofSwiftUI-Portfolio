//
//  DetailView.swift
//  PersonLookup
//
//  Created by Annalie Kruseman on 12/8/22.
//

import SwiftUI
import MapKit

struct DetailView: View {
    let person: Person

    @StateObject private var viewModel = ViewModel()

    @State private var image: Image?
    @State var mapRegion: MKCoordinateRegion
    
    var body: some View {
            VStack {
                Text(person.locationName)
                    .font(.title)
                    .frame(alignment: .leading)
                Text(person.name)
                    .italic()
                    .frame(alignment: .leading)
                
                image?
                    .resizable()
                    .scaledToFit()
                
                Map(coordinateRegion: $mapRegion, annotationItems: viewModel.person) { person in
//                    MapMarker(coordinate: person.coordinate)
                    MapAnnotation(coordinate: person.coordinate) {
                        VStack {
                            Image(systemName: "pin.fill")
                                .foregroundColor(.red)
                            
                            Text(person.locationName)
                                .fixedSize()
                                .bold()
                        }
                    }
                }
            }
            .onAppear(perform: loadImage)
    }
    
    func loadImage() {
        image = person.convertDataToImage()
        mapRegion.center = person.coordinate
        mapRegion.span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(person: Person.example, mapRegion: MKCoordinateRegion())
    }
}
