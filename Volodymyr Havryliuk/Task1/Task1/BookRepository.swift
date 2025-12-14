//
//  BookRepository.swift
//  Task1
//
//  Created by v on 14.12.2025.
//

import Foundation
import SwiftData

actor BookDataActor {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchBookIDs() throws -> [UUID] {
        let descriptor = FetchDescriptor<Book>()
        let books = try modelContext.fetch(descriptor)
        return books.map(\.id)
    }

    func insertNewBook() -> UUID {
        let book = Book(title: "New Book")
        modelContext.insert(book)
        return book.id
    }

    func deleteBook(by id: UUID) throws {
        let descriptor = FetchDescriptor<Book>(
            predicate: #Predicate { $0.id == id }
        )
        if let book = try modelContext.fetch(descriptor).first {
            modelContext.delete(book)
        }
    }

    func insertBook(from item: GoogleBookItem) -> UUID {
        let info = item.volumeInfo
        let secureImg = info.imageLinks?.thumbnail?.replacingOccurrences(
            of: "http://",
            with: "https://"
        )

        let book = Book(
            title: info.title,
            author: info.authors?.joined(separator: ", ") ?? "Unknown",
            desc: info.description ?? "No description available.",
            coverURL: secureImg
        )
        modelContext.insert(book)
        return book.id
    }
}

protocol BookRepositoryProtocol: Sendable {
    func fetchBooks() async throws -> [UUID]
    func addNewBook() async -> UUID
    func deleteBook(by id: UUID) async throws
    func saveBook(from item: GoogleBookItem) async -> UUID
    func searchRemoteBooks(query: String) async throws -> [GoogleBookItem]
}

final class BookRepository: BookRepositoryProtocol {
    private let apiService: BookAPIService
    private let dataActor: BookDataActor

    init(apiService: BookAPIService, modelContext: ModelContext) {
        self.apiService = apiService
        self.dataActor = BookDataActor(modelContext: modelContext)
    }

    func fetchBooks() async throws -> [UUID] {
        try await dataActor.fetchBookIDs()
    }

    func addNewBook() async -> UUID {
        await dataActor.insertNewBook()
    }

    func deleteBook(by id: UUID) async throws {
        try await dataActor.deleteBook(by: id)
    }

    func saveBook(from item: GoogleBookItem) async -> UUID {
        await dataActor.insertBook(from: item)
    }

    func searchRemoteBooks(query: String) async throws -> [GoogleBookItem] {
        try await apiService.searchBooks(query: query)
    }
}
