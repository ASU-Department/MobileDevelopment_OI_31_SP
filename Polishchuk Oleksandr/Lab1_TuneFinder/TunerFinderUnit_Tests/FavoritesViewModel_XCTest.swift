import XCTest
@testable import TuneFinder

final class FavoritesViewModel_XCTest: XCTestCase {

    @MainActor
    func testLoadSuccessPopulatesItems() async {
        let repo = MockSongsRepository()
        let vm = FavoritesViewModel(repository: repo, autoLoadOnInit: false)

        await vm.load()

        XCTAssertFalse(vm.items.isEmpty)
        XCTAssertNil(vm.errorMessage)
        XCTAssertFalse(vm.isLoading)
    }

    @MainActor
    func testRemoveRemovesItem() async throws {
        let repo = MockSongsRepository()
        let vm = FavoritesViewModel(repository: repo, autoLoadOnInit: false)

        await vm.load()
        let first = try XCTUnwrap(vm.items.first)

        await vm.removeAsync(first)

        XCTAssertFalse(vm.items.contains(where: { $0.id == first.id }))
    }


    @MainActor
    func testClearAllEmptiesItems() async {
        let repo = MockSongsRepository()
        let vm = FavoritesViewModel(repository: repo, autoLoadOnInit: false)

        await vm.load()
        XCTAssertFalse(vm.items.isEmpty)

        await vm.clearAllAsync()

        XCTAssertTrue(vm.items.isEmpty)
    }
}
