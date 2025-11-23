//
//  ContentView.swift
//  Task1
//
//  Created by v on 17.10.2025.
//

import SwiftUI

struct Book: Hashable, Identifiable {
    let id = UUID()
    let title: String
    var isRead: Bool = false
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
                        .frame(height: 80)
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
                                BookRow(book: $book)
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
}

struct BookRow: View {
    @Binding var book: Book
    
    var body: some View {
        Toggle(book.title, isOn: $book.isRead)
        
    }
}

struct BookFormView: View {
    @Binding var book: Book
    var body: some View {
        Text(book.title)
    }
}

#Preview {
    ContentView()
}
