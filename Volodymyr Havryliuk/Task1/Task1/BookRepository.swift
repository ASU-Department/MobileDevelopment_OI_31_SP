//
//  BookRepository.swift
//  Task1
//
//  Created by v on 14.12.2025.
//

import Foundation
import SwiftData

actor BookDataActor {
    private let container: ModelContainer
    private let context: ModelContext

    init(container: ModelContainer) {
        self.container = container
        self.context = ModelContext(container)  // new isolated context using same persistent container
        self.context.autosaveEnabled = false
    }

    func fetchBookIDs() throws -> [UUID] {
        let descriptor = FetchDescriptor<Book>()
        let books = try context.fetch(descriptor)
        return books.map(\.id)
    }

    func insertNewBook() throws -> UUID {
        let book = Book(title: "New Book")
        context.insert(book)
        try context.save()
        Task { @MainActor in
            NotificationCenter.default.post(name: .backgroundContextDidSave, object: nil)
        }
        return book.id
    }

    func deleteBook(by id: UUID) throws {
        let descriptor = FetchDescriptor<Book>(
            predicate: #Predicate { $0.id == id }
        )
        if let book = try context.fetch(descriptor).first {
            context.delete(book)
            try context.save()
            Task { @MainActor in
                NotificationCenter.default.post(name: .backgroundContextDidSave, object: nil)
            }
        }
    }

    func insertBook(from item: GoogleBookItem) throws -> UUID {
        let info = item.volumeInfo
        let secureImg = info.imageLinks?.thumbnail?.replacingOccurrences(
            of: "http://", with: "https://"
        )

        let book = Book(
            title: info.title,
            author: info.authors?.joined(separator: ", ") ?? "Unknown",
            desc: info.description ?? "No description available.",
            coverURL: secureImg
        )
        context.insert(book)
        try context.save()
        
        Task { @MainActor in
            NotificationCenter.default.post(name: .backgroundContextDidSave, object: nil)
        }
        return book.id
    }
}

protocol BookRepositoryProtocol: Sendable {
    func fetchBooks() async throws -> [UUID]
    func addNewBook() async throws -> UUID
    func deleteBook(by id: UUID) async throws
    func saveBook(from item: GoogleBookItem) async throws -> UUID
    func searchRemoteBooks(query: String) async throws -> [GoogleBookItem]
}

final class BookRepository: BookRepositoryProtocol {
    private let apiService: BookAPIService
    private let dataActor: BookDataActor

    init(apiService: BookAPIService, container: ModelContainer) {
        self.apiService = apiService
        self.dataActor = BookDataActor(container: container)
    }

    func fetchBooks() async throws -> [UUID] {
        try await dataActor.fetchBookIDs()
    }

    func addNewBook() async throws -> UUID {
        try await dataActor.insertNewBook()
    }

    func deleteBook(by id: UUID) async throws {
        try await dataActor.deleteBook(by: id)
    }

    func saveBook(from item: GoogleBookItem) async throws -> UUID {
        try await dataActor.insertBook(from: item)
    }

    func searchRemoteBooks(query: String) async throws -> [GoogleBookItem] {
        try await apiService.searchBooks(query: query)
    }
}

extension Notification.Name {
    static let backgroundContextDidSave = Notification.Name("backgroundContextDidSave")
}
