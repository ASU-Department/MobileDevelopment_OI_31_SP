//
//  Search.swift
//  Task1
//
//  Created by v on 23.11.2025.
//

import SwiftUI
import SwiftData
import Combine

@MainActor
final class SearchBooksViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var books: [GoogleBookItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showingError = false

    private let repository: BookRepositoryProtocol
    private let modelContext: ModelContext
    private let lastSearchKey = "lastSearchQuery"

    init(repository: BookRepositoryProtocol, modelContext: ModelContext) {
        self.repository = repository
        self.modelContext = modelContext
        self.query = UserDefaults.standard.string(forKey: lastSearchKey) ?? ""
    }

    func onAppear() {
        if query.isEmpty {
            query = UserDefaults.standard.string(forKey: lastSearchKey) ?? ""
        }
    }

    func performSearch() {
        guard !query.isEmpty else { return }
        UserDefaults.standard.set(query, forKey: lastSearchKey)
        isLoading = true
        errorMessage = nil

        Task {
            do {
                books = try await repository.searchRemoteBooks(query: query)
            } catch {
                errorMessage = "Failed to load books. Please check your internet connection."
                showingError = true
            }
            isLoading = false
        }
    }

    func saveBookToLibrary(item: GoogleBookItem) {
        Task {
            _ = await repository.saveBook(from: item)
        }
    }
}

struct SearchBooksView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: SearchBooksViewModel

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Search title or author...", text: $viewModel.query)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit { viewModel.performSearch() }

                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Button("Search") { viewModel.performSearch() }
                    }
                }
                .padding()

                if let error = viewModel.errorMessage {
                    Text(error).foregroundStyle(.red).padding()
                }

                List(viewModel.books) { item in
                    HStack(alignment: .top) {
                        if let urlStr = item.volumeInfo.imageLinks?.thumbnail?
                            .replacingOccurrences(of: "http://", with: "https://"),
                            let url = URL(string: urlStr)
                        {
                            AsyncImage(url: url) { image in
                                image.resizable().scaledToFit()
                            } placeholder: {
                                Color.gray.opacity(0.3)
                            }
                            .frame(width: 50, height: 75)
                            .cornerRadius(4)
                        } else {
                            Rectangle()
                                .fill(.gray.opacity(0.3))
                                .frame(width: 50, height: 75)
                        }

                        VStack(alignment: .leading) {
                            Text(item.volumeInfo.title)
                                .font(.headline)
                                .lineLimit(2)
                            Text(item.volumeInfo.authors?.joined(separator: ", ")
                                ?? "Unknown Author")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Button {
                            viewModel.saveBookToLibrary(item: item)
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
            .onAppear { viewModel.onAppear() }
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
        }
    }
}
