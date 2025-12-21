import Testing
import SwiftData
import Foundation
@testable import Task1

@Suite(.serialized)
struct SearchBooksViewModelTests {

    // MARK: - Test doubles

    @MainActor
    final class RepoStub: BookRepositoryProtocol {
        var lastSavedItemID: String?
        var searchResponse: [GoogleBookItem] = []

        func fetchBooks() async throws -> [UUID] { [] }
        func addNewBook() async throws -> UUID { UUID() }
        func deleteBook(by id: UUID) async throws {}
        func saveBook(from item: GoogleBookItem) async throws -> UUID {
            lastSavedItemID = item.id
            return UUID()
        }
        func searchRemoteBooks(query: String) async throws -> [GoogleBookItem] {
            return searchResponse
        }
    }

    // MARK: - Helpers

    @MainActor
    private func makeModelContext() throws -> ModelContext {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Book.self, configurations: config)
        return ModelContext(container)
    }

    // MARK: - Tests

    @Test
    @MainActor
    func onAppearRestoresLastQuery() throws {
        // Given: put a value into standard defaults under the key used by the VM
        UserDefaults.standard.set("stored query", forKey: "lastSearchQuery")

        let repo = RepoStub()
        let ctx = try makeModelContext()
        let vm = SearchBooksViewModel(repository: repo, modelContext: ctx)

        // When
        vm.onAppear()

        // Then
        #expect(vm.query == "stored query")
    }

    @Test
    @MainActor
    func performSearchPersistsQueryAndLoadsBooks() async throws {
        // Given
        UserDefaults.standard.removeObject(forKey: "lastSearchQuery")

        let sampleItem = GoogleBookItem(
            id: "gb-1",
            volumeInfo: VolumeInfo(
                title: "Swift",
                authors: ["Apple"],
                description: "Docs",
                imageLinks: ImageLinks(thumbnail: nil)
            )
        )

        let repo = RepoStub()
        repo.searchResponse = [sampleItem]

        let ctx = try makeModelContext()
        let vm = SearchBooksViewModel(repository: repo, modelContext: ctx)

        // When
        vm.query = "swift books"
        vm.performSearch()

        // Await the async Task launched inside performSearch by polling isLoading
        // Keep it simple and robust with a short wait.
        try await Task.sleep(nanoseconds: 80_000_000)

        // Then
        #expect(vm.isLoading == false)
        #expect(vm.errorMessage == nil)
        #expect(vm.books.count == 1)
        #expect(vm.books.first?.id == "gb-1")

        // Verify it persisted to UserDefaults.standard (as per VM code)
        #expect(UserDefaults.standard.string(forKey: "lastSearchQuery") == "swift books")
    }

    @Test
    @MainActor
    func saveBookCallsRepository() async throws {
        // Given
        let repo = RepoStub()
        let ctx = try makeModelContext()
        let vm = SearchBooksViewModel(repository: repo, modelContext: ctx)

        let item = GoogleBookItem(
            id: "gb-2",
            volumeInfo: VolumeInfo(
                title: "Combine",
                authors: ["Apple"],
                description: nil,
                imageLinks: nil
            )
        )

        // When
        vm.saveBookToLibrary(item: item)
        try await Task.sleep(nanoseconds: 50_000_000)

        // Then
        #expect(repo.lastSavedItemID == "gb-2")
    }
}
