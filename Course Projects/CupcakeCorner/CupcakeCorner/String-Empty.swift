//
//  String-Empty.swift
//  CupcakeCorner
//
//  Created by Annalie Kruseman on 10/13/22.
//

import Foundation

extension String {
    var isWhitespace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
