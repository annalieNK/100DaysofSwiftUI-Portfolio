//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Annalie Kruseman on 1/25/23.
//

import SwiftUI

struct ContentView: View {
    let colors: [Color] = [.red, .green, .blue, .orange, .pink, .purple, .yellow]

    var body: some View {
        GeometryReader { fullView in
            ScrollView(.vertical) {
                ForEach(0..<50) { index in
                    GeometryReader { geo in
                        Text("Row #\(index)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            // set a fixed set of colors
                            // .background(colors[index % 7])
                            // create a smooth transition of colors, make the hue not go less than 1
                            .background(Color(hue: min(1, geo.frame(in: .global).minY / fullView.size.height), saturation: 1, brightness: 1))

                            .rotation3DEffect(.degrees(geo.frame(in: .global).minY - fullView.size.height / 2) / 5, axis: (x: 0, y: 1, z: 0))
                            // have the views fade out in the Y range of 0 through 200
                            .opacity(geo.frame(in: .global).minY / 200)
                            // scale the size based on the position, but do it by a factor
                            .scaleEffect(max(0.5, geo.frame(in: .global).minY / 400))
                    }
                    .frame(height: 40)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
