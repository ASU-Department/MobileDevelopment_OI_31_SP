//
//  Search.swift
//  Task1
//
//  Created by v on 23.11.2025.
//

import SwiftUI
import SwiftData

struct SearchBooksView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var query: String = ""
    @State private var books: [GoogleBookItem] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showingError = false
    
    // UserDefaults
    @AppStorage("lastSearchQuery") private var lastSearchQuery: String = ""
    
    let apiService = BookAPIService()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Search title or author...", text: $query)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit { performSearch() }
                    
                    if isLoading {
                        ProgressView()
                    } else {
                        Button("Search") { performSearch() }
                    }
                }
                .padding()
                
                if let error = errorMessage {
                    Text(error).foregroundStyle(.red).padding()
                }
                
                List(books) { item in
                    HStack(alignment: .top) {
                        if let urlString = item.volumeInfo.imageLinks?.thumbnail?.replacingOccurrences(of: "http://", with: "https://"),
                           let url = URL(string: urlString) {
                            AsyncImage(url: url) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                Color.gray.opacity(0.3)
                            }
                            .frame(width: 50, height: 75)
                            .cornerRadius(4)
                        } else {
                            Rectangle().fill(.gray.opacity(0.3)).frame(width: 50, height: 75)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(item.volumeInfo.title).font(.headline).lineLimit(2)
                            Text(item.volumeInfo.authors?.joined(separator: ", ") ?? "Unknown Author")
                                .font(.caption).foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Button {
                            saveBookToLibrary(item: item)
                        } label: {
                            Image(systemName: "arrow.down.circle.fill")
                                .font(.title2)
                                .foregroundStyle(.blue)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .navigationTitle("Google Books")
            .onAppear {
                if query.isEmpty { query = lastSearchQuery }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "Unknown error")
            }
        }
    }
    
    func performSearch() {
        guard !query.isEmpty else { return }
        
        lastSearchQuery = query
        
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                books = try await apiService.searchBooks(query: query)
            } catch {
                errorMessage = "Failed to load books. Please check your internet connection."
                showingError = true
            }
            isLoading = false
        }
    }
    
    func saveBookToLibrary(item: GoogleBookItem) {
        let info = item.volumeInfo
        let secureImg = info.imageLinks?.thumbnail?.replacingOccurrences(of: "http://", with: "https://")
        
        let newBook = Book(
            title: info.title,
            author: info.authors?.joined(separator: ", ") ?? "Unknown",
            desc: info.description ?? "No description available.",
            coverURL: secureImg
        )
        
        modelContext.insert(newBook)
    }
}
