//
//  CrewView.swift
//  Moonshot
//
//  Created by Annalie Kruseman on 9/29/22.
//

import SwiftUI

struct CrewScroll: View {
    let crew: [MissionView.CrewMember]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(crew, id: \.role) { crewMember in
                    NavigationLink {
//                                    Text("Astronaut details")
                        AstronautView(astronaut: crewMember.astronaut)
                    } label: {
                        HStack {
                            Image(crewMember.astronaut.id)
                                .resizable()
                                .frame(width: 104, height: 72)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .strokeBorder(.white, lineWidth: 1)
                                )
                                .accessibilityAddTraits(.isButton)
                            
                            VStack(alignment: .leading) {
                                Text(crewMember.astronaut.name)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    // replacing "." with a space when read out loud with VoiceOver
                                    .accessibilityLabel(crewMember.astronaut.name.replacingOccurrences(of: ".", with: " "))
                                
                                Text(crewMember.role)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

struct CrewScroll_Previews: PreviewProvider {
    static var previews: some View {
        CrewScroll(crew: [])
    }
}
