//
//  ContentView.swift
//  Task1
//
//  Created by v on 17.10.2025.
//

import SwiftUI

struct Book: Hashable, Identifiable {
    let id = UUID()
    var title: String
    var isRead: Bool = false
    var notes: String = ""
    var rating: Float = 0.0
}

struct ContentView: View {
    @State var books: [Book] = [
    ]
    @State private var path = NavigationPath()
    
    @State var motivation = "You have nothing"
    
    let quotes = [
        "Reading is dreaming with open eyes.",
        "So many books, so little time.",
        "A room without books is like a body without a soul.",
    ]
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                if books.isEmpty {
                    SimpleText(text: motivation)
                        .frame(width: 40, height: 80)
                        .padding(.horizontal)
                    
                    Button("Get motivated") {
                        motivation = quotes.randomElement() ?? "Something is very wrong, someone stole all quotes"
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("BookTracker")
                        .bold()
                        .font(.system(size: 36))
                    List {
                        ForEach($books) { $book in
                            NavigationLink(value: $book.id) {
                                BookRow(book: $book) {
                                    deleteBook(id: $book.id)
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Book Tracker")
            .toolbar {
                Button(action: addNewBook) {
                    Label("Add", systemImage: "plus")
                }
            }
            .navigationDestination(for: UUID.self) { bookId in
                if let index = books.firstIndex(where: { $0.id == bookId }) {
                    BookFormView(book: $books[index])
                        .navigationTitle("Edit Book")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
    
    func addNewBook() {
        let newBook = Book(title: "New Book")
        books.append(newBook)
        path.append(newBook.id)
    }
    
    func deleteBook(id: UUID) {
        if let index = books.firstIndex(where: { $0.id == id }) {
            books.remove(at: index)
        }
    }
}

struct BookRow: View {
    @Binding var book: Book
    var onDelete: () -> Void
    
    var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(book.title)
                        .font(.headline)
                    Text(String(format: "Rating: %.1f", book.rating))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Toggle(isOn: $book.isRead) {
                    Text("Read")
                }
                .labelsHidden()
            }
            .padding(.vertical, 4)
            .contextMenu {
                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Label("Delete Book", systemImage: "trash")
                }
            }
        }
}

#Preview {
    ContentView()
}
