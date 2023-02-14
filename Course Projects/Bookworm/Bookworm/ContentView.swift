//
//  ContentView.swift
//  Bookworm
//
//  Created by Annalie Kruseman on 10/17/22.
//

import SwiftUI

struct ContentView: View {
    // ask for the current managed object context
    @Environment(\.managedObjectContext) var moc
    // read data (Entity is named 'Book')
    @FetchRequest(sortDescriptors: [
//        SortDescriptor(\.rating),
        SortDescriptor(\.title),
        SortDescriptor(\.author)
    ]) var books: FetchedResults<Book>
    
    // sheet reference
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView {
            // Text("Count: \(books.count)")
            List {
                ForEach(books) { book in
                    NavigationLink {
                        // Text(book.title ?? "Unknown Title")
                        DetailView(book: book)
                    } label: {
                        HStack {
                            EmojiRatingView(rating: book.rating)
                                .font(.largeTitle)
                            
                            VStack(alignment: .leading) {
                                Text(book.title ?? "Unknown Title")
                                    .font(.headline)
//                                    .foregroundColor(book.rating == 1 ? .red : .primary)
                                Text(book.author ?? "Unknown Author")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .opacity(book.rating == 1 ? 0.5 : 1)
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("Bookworm")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddScreen.toggle()
                    } label: {
                        Label("Add Book", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookView()
            }
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            // find this book in our fetch request
            let book = books[offset]

            // delete it from the context
            moc.delete(book)
        }

        // save the context
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
