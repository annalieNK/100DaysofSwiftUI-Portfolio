//
//  PersonListView.swift
//  PersonLookup
//
//  Created by Annalie Kruseman on 12/7/22.
//

import SwiftUI
import UIKit

struct PersonListView: View {
    let person: Person
    @State private var image: Image?

    var body: some View {
        HStack {
            image?
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 100, height: 100)
                .shadow(radius: 2)
            VStack {
                Text(person.locationName)
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(person.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
        }
        .onAppear(perform: loadImage)
    }
    
    func loadImage() {
        image = person.convertDataToImage()
    }
}

struct PersonListView_Previews: PreviewProvider {
    static var previews: some View {
        PersonListView(person: Person.example)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}  
