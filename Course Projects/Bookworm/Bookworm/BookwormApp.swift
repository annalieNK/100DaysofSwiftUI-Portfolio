//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Annalie Kruseman on 10/17/22.
//

import SwiftUI

@main
struct BookwormApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                // refer to managedObjectContext, meaning, managed by CoreData
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
