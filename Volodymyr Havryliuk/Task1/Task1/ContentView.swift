//
//  ContentView.swift
//  Task1
//
//  Created by v on 17.10.2025.
//

import SwiftUI
import SwiftData

@Model
class Book {
    var id: UUID
    var title: String
    var author: String
    var desc: String
    var coverURL: String?
    var isRead: Bool
    var notes: String
    var rating: Float
    
    init(title: String, author: String = "", desc: String = "", coverURL: String? = nil, isRead: Bool = false, notes: String = "", rating: Float = 0.0) {
        self.id = UUID()
        self.title = title
        self.author = author
        self.desc = desc
        self.coverURL = coverURL
        self.isRead = isRead
        self.notes = notes
        self.rating = rating
    }}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Book.title) private var books: [Book]
    
    @State private var path = NavigationPath()
    @State private var showingSearch = false
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
                    VStack {
                        Text(motivation)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button("Get motivated") {
                            motivation = quotes.randomElement() ?? "No quotes found"
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(height: 200)
                    
                } else {
                    Text("BookTracker")
                        .bold()
                        .font(.system(size: 36))
                    
                    List {
                        ForEach(books) { book in
                            NavigationLink(value: book) {
                                BookRow(book: book, onDelete: {
                                    deleteBook(book: book)
                                })
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Book Tracker")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: addNewBook) {
                        Label("Add", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingSearch = true
                    } label: {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                }
            }
            .navigationDestination(for: Book.self) { book in
                BookFormView(book: book)
                    .navigationTitle("Edit Book")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .sheet(isPresented: $showingSearch) {
                SearchBooksView()
            }
        }
    }
    
    func addNewBook() {
        let newBook = Book(title: "New Book")
        modelContext.insert(newBook)
        path.append(newBook)
    }
    
    func deleteBook(book: Book) {
        // fix for a ForEach, crashes when deleting from rear of a list
        DispatchQueue.main.async {
            withAnimation {
                modelContext.delete(book)
            }
        }
    }
}

struct BookRow: View {
    @Bindable var book: Book
    var onDelete: () -> Void
    
    var body: some View {
        HStack {
            if let urlString = book.coverURL, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 40, height: 60)
                .cornerRadius(4)
            }
            
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.headline)
                if !book.author.isEmpty {
                    Text(book.author)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
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
    // need for previews to change how data is stored
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Book.self, configurations: config)
    return ContentView()
        .modelContainer(container)
}
