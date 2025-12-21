import Testing
@testable import Eventive

@MainActor
struct EventiveTests {

    @Test
    func emptySearch_doesNotChangeState() {
        let repo = FakeRepository()
        let vm = EventsViewModel(repository: repo)

        vm.search(keyword: "")

        #expect(vm.events.isEmpty)
        #expect(vm.errorMessage == nil)
        #expect(vm.isLoading == false)
    }
}

@available(iOS 17, *)
final class FakeRepository: EventsRepository {
    func searchEvents(keyword: String) async throws -> [Event] {
        []
    }
}
