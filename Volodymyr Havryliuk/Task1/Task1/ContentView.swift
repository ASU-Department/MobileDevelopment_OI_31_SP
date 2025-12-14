//
//  ContentView.swift
//  Task1
//
//  Created by v on 17.10.2025.
//

import SwiftUI
import SwiftData
import Combine

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
    
    init(
        title: String,
        author: String = "",
        desc: String = "",
        coverURL: String? = nil,
        isRead: Bool = false,
        notes: String = "",
        rating: Float = 0.0
    ) {
        self.id = UUID()
        self.title = title
        self.author = author
        self.desc = desc
        self.coverURL = coverURL
        self.isRead = isRead
        self.notes = notes
        self.rating = rating
    }
}

@MainActor
final class ContentViewModel: ObservableObject {
    @Published var path = NavigationPath()
    @Published var showingSearch = false
    @Published var motivation = "You have nothing"
    @Published var books: [Book] = []
    
    let quotes = [
        "Reading is dreaming with open eyes.",
        "So many books, so little time.",
        "A room without books is like a body without a soul.",
    ]
    
    var modelContext: ModelContext?
    
    func updateBooks(_ fetched: [Book]) {
        books = fetched.sorted {
            $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
        }
    }
    
    func getMotivation() {
        motivation = quotes.randomElement() ?? "No quotes found"
    }
    
    func addNewBook() {
        guard let ctx = modelContext else { return }
        let newBook = Book(title: "New Book")
        ctx.insert(newBook)
        path.append(newBook)
    }
    
    func deleteBook(_ book: Book) {
        guard let ctx = modelContext else { return }
        DispatchQueue.main.async {
            withAnimation {
                ctx.delete(book)
            }
        }
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    // Fetch raw data only; sorting is handled in the ViewModel
    @Query private var fetchedBooks: [Book]
    
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.path) {
            VStack {
                if viewModel.books.isEmpty {
                    VStack {
                        Text(viewModel.motivation)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        Button("Get motivated") {
                            viewModel.getMotivation()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(height: 200)
                    
                } else {
                    Text("BookTracker")
                        .bold()
                        .font(.system(size: 36))
                    
                    List {
                        ForEach(viewModel.books) { book in
                            NavigationLink(value: book) {
                                BookRow(book: book, onDelete: {
                                    viewModel.deleteBook(book)
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
                    Button(action: viewModel.addNewBook) {
                        Label("Add", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showingSearch = true
                    } label: {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                }
            }
            .navigationDestination(for: Book.self) { book in
                BookFormView(viewModel: BookFormViewModel(book: book))
                    .navigationTitle("Edit Book")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .sheet(isPresented: $viewModel.showingSearch) {
                SearchBooksView(
                    viewModel: SearchBooksViewModel(
                        apiService: BookAPIService(),
                        modelContext: modelContext
                    )
                )
            }
        }
        .onAppear {
            viewModel.modelContext = modelContext
            viewModel.updateBooks(fetchedBooks)
        }
        .onChange(of: fetchedBooks) { newValue in
            viewModel.updateBooks(newValue)
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
