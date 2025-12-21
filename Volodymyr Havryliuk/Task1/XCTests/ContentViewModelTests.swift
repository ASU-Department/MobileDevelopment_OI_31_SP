import XCTest
@testable import Task1
import SwiftData
import SwiftUI

@MainActor
final class ContentViewModel_AllTests: XCTestCase {

    // MARK: - In-memory SwiftData helper (main-actor only)

    private func makeInMemoryContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: Book.self, configurations: config)
    }

    // MARK: - 1) Motivation quote selection (pure logic, but keep main-actor for VM)

    func testGetMotivationSetsOneOfQuotes() async {
        let vm = ContentViewModel()
        XCTAssertEqual(vm.motivation, "You have nothing")

        vm.getMotivation()

        let quotes = [
            "Reading is dreaming with open eyes.",
            "So many books, so little time.",
            "A room without books is like a body without a soul."
        ]
        XCTAssertTrue(quotes.contains(vm.motivation))
    }

    // MARK: - 2) Reload fetches books from SwiftData via configure(modelContext:)

    func testReloadFetchesBooksFromModelContext() async throws {
        // Everything on main actor
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)
        
        // Seed data on main actor
        let b1 = Book(title: "Clean Code", author: "Robert C. Martin", rating: 4.5)
        let b2 = Book(title: "The Pragmatic Programmer", author: "Andrew Hunt", rating: 4.0)
        context.insert(b1)
        context.insert(b2)
        try context.save()
        
        let vm = ContentViewModel()
        vm.configure(modelContext: context)

        // Act
        vm.reload()

        // Assert
        XCTAssertEqual(vm.books.count, 2)
        XCTAssertEqual(
            Set(vm.books.map(\.title)),
            Set(["Clean Code", "The Pragmatic Programmer"])
        )
    }

    // MARK: - 3) Background save notification triggers reload

    func testBackgroundSaveNotificationTriggersReload() async throws {
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)

        // Start with one book
        context.insert(Book(title: "Book 1"))
        try context.save()

        let vm = ContentViewModel()
        vm.configure(modelContext: context)
        XCTAssertEqual(vm.books.count, 1)

        // Insert a second book
        context.insert(Book(title: "Book 2"))
        try context.save()

        // Post on main queue because observer is registered on .main queue
        NotificationCenter.default.post(name: .backgroundContextDidSave, object: nil)

        // Allow the main-queue observer to run and vm.reload() to complete
        let exp = expectation(description: "Reload after background save")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            exp.fulfill()
        }
        await fulfillment(of: [exp], timeout: 1.0)

        XCTAssertEqual(vm.books.count, 2)
        XCTAssertTrue(vm.books.contains(where: { $0.title == "Book 2" }))
    }

    // MARK: - 4) addNewBook/deleteBook do not crash (stability)

    func testAddAndDeleteNoCrash() async throws {
        let container = try makeInMemoryContainer()
        let context = ModelContext(container)

        let vm = ContentViewModel()
        vm.configure(modelContext: context)

        let book = Book(title: "Any")
        vm.addNewBook()
        vm.deleteBook(book)

        // Let any spawned Tasks settle
        try await Task.sleep(nanoseconds: 60_000_000)

        XCTAssertTrue(true)
    }
}
