//
//  AstronautView.swift
//  Moonshot
//
//  Created by Annalie Kruseman on 9/29/22.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    
    var body: some View {
        // add scrollview
        ScrollView {
            VStack {
                // add image of astronaut
                Image(astronaut.id)
                    .resizable()
                    .scaledToFit()
                    .accessibilityHidden(true)
                
                // and astronaut description
                Text(astronaut.description)
                    .padding()
            }
        }
        .background(.darkBackground)
        .navigationTitle(astronaut.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        AstronautView(astronaut: astronauts["armstrong"]!)
            .preferredColorScheme(.dark)
    }
}
