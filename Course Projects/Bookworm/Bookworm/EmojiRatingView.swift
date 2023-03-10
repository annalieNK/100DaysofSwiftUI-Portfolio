//
//  EmojiRatingView.swift
//  Bookworm
//
//  Created by Annalie Kruseman on 10/24/22.
//

import SwiftUI

struct EmojiRatingView: View {
    let rating: Int16

    var body: some View {
        switch rating {
        case 1:
            Text("๐ตโ๐ซ")
        case 2:
            Text("๐คจ")
        case 3:
            Text("๐")
        case 4:
            Text("๐")
        default:
            Text("๐คฉ")
        }
    }
}

struct EmojiRatingView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiRatingView(rating: 3)
    }
}
