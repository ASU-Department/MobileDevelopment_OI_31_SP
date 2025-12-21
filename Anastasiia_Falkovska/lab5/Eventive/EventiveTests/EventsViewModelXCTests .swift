import XCTest
@testable import Eventive

@available(iOS 17, *)
@MainActor
final class EventsViewModelXCTests: XCTestCase {

    final class MockRepository: EventsRepository {

        var result: Result<[Event], Error> = .success([])
        private(set) var receivedKeyword: String?
        private(set) var callCount = 0

        func searchEvents(keyword: String) async throws -> [Event] {
            callCount += 1
            receivedKeyword = keyword

            switch result {
            case .success(let events):
                return events
            case .failure(let error):
                throw error
            }
        }
    }

    func test_emptySearch_doesNothing() {
        let repo = MockRepository()
        let vm = EventsViewModel(repository: repo)

        vm.search(keyword: "")

        XCTAssertTrue(vm.events.isEmpty)
        XCTAssertNil(vm.errorMessage)
        XCTAssertFalse(vm.isLoading)
        XCTAssertEqual(repo.callCount, 0)
    }

    func test_search_setsLoadingTrueThenFalse() async {
        let event = Event(
            id: "1",
            name: "Concert",
            city: "Kyiv",
            date: "2025-01-01"
        )

        let repo = MockRepository()
        repo.result = .success([event])

        let vm = EventsViewModel(repository: repo)

        vm.search(keyword: "music")
        XCTAssertTrue(vm.isLoading)

        try? await Task.sleep(for: .milliseconds(100))

        XCTAssertFalse(vm.isLoading)
    }

    func test_successSearch_setsEvents_andCallsRepository() async {
        let event = Event(
            id: "1",
            name: "Concert",
            city: "Kyiv",
            date: "2025-01-01"
        )

        let repo = MockRepository()
        repo.result = .success([event])

        let vm = EventsViewModel(repository: repo)

        vm.search(keyword: "music")
        try? await Task.sleep(for: .milliseconds(100))

        XCTAssertEqual(vm.events.count, 1)
        XCTAssertEqual(vm.events.first?.name, "Concert")
        XCTAssertEqual(repo.receivedKeyword, "music")
        XCTAssertEqual(repo.callCount, 1)
    }

    func test_searchFailure_setsErrorMessage() async {
        let repo = MockRepository()
        repo.result = .failure(URLError(.badServerResponse))

        let vm = EventsViewModel(repository: repo)

        vm.search(keyword: "music")
        try? await Task.sleep(for: .milliseconds(100))

        XCTAssertEqual(vm.errorMessage, "Не вдалося завантажити події")
        XCTAssertFalse(vm.isLoading)
    }
}
