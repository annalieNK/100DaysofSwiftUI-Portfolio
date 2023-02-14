//
//  FileManager-DocumentsDirectory.swift
//  Flashzilla
//
//  Created by Annalie Kruseman on 1/25/23.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
