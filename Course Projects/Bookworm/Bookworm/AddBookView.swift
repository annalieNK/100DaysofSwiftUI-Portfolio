//
//  AddVookView.swift
//  Bookworm
//
//  Created by Annalie Kruseman on 10/24/22.
//

import SwiftUI

struct AddBookView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss

    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = ""
    @State private var review = ""
//    @State private var date = Date.now

    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Thriller", "Novel", "Non-Fiction", "Memoir"]

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)

                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }

                Section {
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a review")
                }

                Section {
                    Button("Save") {
                        let newBook = Book(context: moc)
                        newBook.id = UUID()
                        newBook.title = title
                        newBook.author = author
                        newBook.rating = Int16(rating)
                        newBook.review = review
                        newBook.genre = genre
                        newBook.date = Date.now

                        try? moc.save()
                        dismiss()
                    }
                }
                .disabled(disableForm)
            }
            .navigationTitle("Add Book")
        }
    }
    
    var disableForm: Bool {
        title.isEmpty || author.isEmpty || genre.isEmpty
        }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
