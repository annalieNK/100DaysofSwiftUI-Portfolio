//
//  FileManager-DocumentsDirectory.swift
//  HotProspects
//
//  Created by Annalie Kruseman on 1/19/23.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
