import XCTest
@testable import ArtCurator

@MainActor
final class ArtworkListViewModelXCTests: XCTestCase {
    var sut: ArtworkListViewModel!
    var mockRepository: MockArtworkRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockArtworkRepository()
        sut = ArtworkListViewModel(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertTrue(sut.artworks.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertFalse(sut.isLoadingMore)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isOffline)
    }
    
    func testFetchArtworksSuccess() async {
        let testArtwork = createTestArtwork(id: 1, title: "Mona Lisa")
        mockRepository.searchResult = .success([1])
        mockRepository.fetchDetailResult = .success(testArtwork)
        
        await sut.fetchArtworks()
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.artworks.count, 1)
        XCTAssertEqual(sut.artworks.first?.title, "Mona Lisa")
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(mockRepository.searchCallCount, 1)
    }
    
    func testFetchArtworksEmptyResult() async {
        mockRepository.searchResult = .success([])
        
        await sut.fetchArtworks()
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.artworks.isEmpty)
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.errorMessage?.contains("No artworks found") ?? false)
    }
    
    func testFetchArtworksNetworkError() async {
        mockRepository.searchResult = .failure(MockError.networkError)
        mockRepository.loadLocalResult = .success([])
        
        await sut.fetchArtworks()
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.isOffline)
        XCTAssertNotNil(sut.errorMessage)
    }
    
    func testFetchArtworksFallsBackToLocalStorage() async {
        let localArtwork = createTestArtwork(id: 99, title: "Local Artwork")
        mockRepository.searchResult = .failure(MockError.networkError)
        mockRepository.loadLocalResult = .success([localArtwork])
        
        await sut.fetchArtworks()
        
        XCTAssertTrue(sut.isOffline)
        XCTAssertEqual(sut.artworks.count, 1)
        XCTAssertEqual(sut.artworks.first?.title, "Local Artwork")
    }
    
    func testSearchQueryUsesDefaultWhenEmpty() async {
        sut.searchQuery = ""
        mockRepository.searchResult = .success([])
        
        await sut.fetchArtworks()
        
        XCTAssertEqual(mockRepository.lastSearchQuery, "painting")
    }
    
    func testSearchQueryUsesUserInput() async {
        sut.searchQuery = "van gogh"
        mockRepository.searchResult = .success([])
        
        await sut.fetchArtworks()
        
        XCTAssertEqual(mockRepository.lastSearchQuery, "van gogh")
    }
    
    func testFilterFavorites() async {
        let favorite = createTestArtwork(id: 1, title: "Favorite", isFavorite: true)
        let nonFavorite = createTestArtwork(id: 2, title: "Non-Favorite", isFavorite: false)
        
        mockRepository.searchResult = .success([1, 2])
        var fetchCount = 0
        mockRepository.fetchDetailResult = .success(favorite)
        
        await sut.fetchArtworks()
        sut.artworks = [favorite, nonFavorite]
        
        XCTAssertEqual(sut.filteredArtworks.count, 2)
        
        sut.filterFavorites = true
        
        XCTAssertEqual(sut.filteredArtworks.count, 1)
        XCTAssertEqual(sut.filteredArtworks.first?.title, "Favorite")
    }
    
    func testToggleFilterFavorites() {
        XCTAssertFalse(sut.filterFavorites)
        
        sut.toggleFilterFavorites()
        
        XCTAssertTrue(sut.filterFavorites)
        
        sut.toggleFilterFavorites()
        
        XCTAssertFalse(sut.filterFavorites)
    }
    
    func testToggleFavoriteForArtwork() async {
        let artwork = createTestArtwork(id: 1, isFavorite: false)
        sut.artworks = [artwork]
        
        await sut.toggleFavorite(for: artwork)
        
        XCTAssertTrue(artwork.isFavorite)
        XCTAssertEqual(mockRepository.updateFavoriteCallCount, 1)
        XCTAssertEqual(mockRepository.lastUpdatedArtworkId, 1)
        XCTAssertEqual(mockRepository.lastUpdatedFavoriteStatus, true)
    }
    
    func testHasMorePages() async {
        mockRepository.searchResult = .success(Array(1...50))
        mockRepository.fetchDetailResult = .success(createTestArtwork())
        
        await sut.fetchArtworks()
        
        XCTAssertTrue(sut.hasMorePages)
    }
    
    func testLoadMoreArtworks() async {
        mockRepository.searchResult = .success(Array(1...30))
        mockRepository.fetchDetailResult = .success(createTestArtwork())
        
        await sut.fetchArtworks()
        let initialCount = sut.artworks.count
        
        await sut.loadMoreArtworks()
        
        XCTAssertGreaterThan(mockRepository.fetchDetailCallCount, initialCount)
    }
    
    func testLoadMoreDoesNotLoadWhenNoMorePages() async {
        mockRepository.searchResult = .success([1, 2, 3])
        mockRepository.fetchDetailResult = .success(createTestArtwork())
        
        await sut.fetchArtworks()
        mockRepository.fetchDetailCallCount = 0
        
        await sut.loadMoreArtworks()
        
        XCTAssertEqual(mockRepository.fetchDetailCallCount, 0)
    }
    
    func testLoadFromLocalStorageSetsOfflineMode() async {
        let localArtwork = createTestArtwork(id: 1, title: "Cached")
        mockRepository.loadLocalResult = .success([localArtwork])
        
        await sut.loadFromLocalStorage()
        
        XCTAssertTrue(sut.isOffline)
        XCTAssertEqual(sut.artworks.count, 1)
    }
    
    func testLoadFromLocalStorageEmptyShowsMessage() async {
        mockRepository.loadLocalResult = .success([])
        
        await sut.loadFromLocalStorage()
        
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.errorMessage?.contains("No cached data") ?? false)
    }
    
    func testLoadFromLocalStorageError() async {
        mockRepository.loadLocalResult = .failure(MockError.databaseError)
        
        await sut.loadFromLocalStorage()
        
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.errorMessage?.contains("Failed to load local data") ?? false)
    }
    
    func testSaveArtworksOnFetch() async {
        mockRepository.searchResult = .success([1])
        mockRepository.fetchDetailResult = .success(createTestArtwork(id: 1))
        
        await sut.fetchArtworks()
        
        XCTAssertEqual(mockRepository.saveArtworksCallCount, 1)
        XCTAssertEqual(mockRepository.lastSavedArtworks?.count, 1)
    }
    
    func testPaginationOffset() async {
        mockRepository.searchResult = .success(Array(1...50))
        mockRepository.fetchDetailResult = .success(createTestArtwork())
        
        await sut.fetchArtworks()
        
        XCTAssertEqual(sut.artworks.count, 20)
        
        await sut.loadMoreArtworks()
        
        XCTAssertEqual(sut.artworks.count, 40)
    }
    
    func testFetchResetsOffset() async {
        mockRepository.searchResult = .success(Array(1...50))
        mockRepository.fetchDetailResult = .success(createTestArtwork())
        
        await sut.fetchArtworks()
        await sut.loadMoreArtworks()
        
        await sut.fetchArtworks()
        
        XCTAssertEqual(sut.artworks.count, 20)
    }
    
    func testFilteredArtworksReturnsAllWhenNotFiltering() {
        let artworks = createTestArtworks(count: 5)
        sut.artworks = artworks
        sut.filterFavorites = false
        
        XCTAssertEqual(sut.filteredArtworks.count, 5)
    }
    
    func testFilteredArtworksReturnsFavoritesWhenFiltering() {
        let artworks = createTestArtworks(count: 4)
        sut.artworks = artworks
        sut.filterFavorites = true
        
        XCTAssertEqual(sut.filteredArtworks.count, 2)
    }
    
    func testIsLoadingDuringFetch() async {
        mockRepository.searchResult = .success([1])
        mockRepository.fetchDetailResult = .success(createTestArtwork())
        mockRepository.searchDelay = 0.1
        
        let task = Task {
            await sut.fetchArtworks()
        }
        
        try? await Task.sleep(nanoseconds: 50_000_000)
        XCTAssertTrue(sut.isLoading)
        
        await task.value
        XCTAssertFalse(sut.isLoading)
    }
    
    func testIsLoadingMoreDuringLoadMore() async {
        mockRepository.searchResult = .success(Array(1...50))
        mockRepository.fetchDetailResult = .success(createTestArtwork())
        
        await sut.fetchArtworks()
        
        mockRepository.fetchDetailDelay = 0.1
        let task = Task {
            await sut.loadMoreArtworks()
        }
        
        try? await Task.sleep(nanoseconds: 50_000_000)
        XCTAssertTrue(sut.isLoadingMore)
        
        await task.value
        XCTAssertFalse(sut.isLoadingMore)
    }
    
    func testLoadMoreDoesNotRunWhileLoading() async {
        mockRepository.searchResult = .success(Array(1...50))
        mockRepository.fetchDetailResult = .success(createTestArtwork())
        
        await sut.fetchArtworks()
        sut.isLoading = true
        
        let initialCallCount = mockRepository.fetchDetailCallCount
        await sut.loadMoreArtworks()
        
        XCTAssertEqual(mockRepository.fetchDetailCallCount, initialCallCount)
    }
    
    func testLoadMoreDoesNotRunWhileLoadingMore() async {
        mockRepository.searchResult = .success(Array(1...50))
        mockRepository.fetchDetailResult = .success(createTestArtwork())
        
        await sut.fetchArtworks()
        sut.isLoadingMore = true
        
        let initialCallCount = mockRepository.fetchDetailCallCount
        await sut.loadMoreArtworks()
        
        XCTAssertEqual(mockRepository.fetchDetailCallCount, initialCallCount)
    }
    
    func testToggleFavoriteToFalse() async {
        let artwork = createTestArtwork(id: 1, isFavorite: true)
        sut.artworks = [artwork]
        
        await sut.toggleFavorite(for: artwork)
        
        XCTAssertFalse(artwork.isFavorite)
        XCTAssertEqual(mockRepository.lastUpdatedFavoriteStatus, false)
    }
    
    func testFetchArtworksClearsErrorMessage() async {
        sut.errorMessage = "Previous error"
        mockRepository.searchResult = .success([1])
        mockRepository.fetchDetailResult = .success(createTestArtwork())
        
        await sut.fetchArtworks()
        
        XCTAssertNil(sut.errorMessage)
    }
    
    func testFetchArtworksClearsOfflineMode() async {
        sut.isOffline = true
        mockRepository.searchResult = .success([1])
        mockRepository.fetchDetailResult = .success(createTestArtwork())
        
        await sut.fetchArtworks()
        
        XCTAssertFalse(sut.isOffline)
    }
    
    func testFetchArtworksSkipsNilDetails() async {
        mockRepository.searchResult = .success([1, 2, 3])
        mockRepository.fetchDetailResult = .success(nil)
        
        await sut.fetchArtworks()
        
        XCTAssertTrue(sut.artworks.isEmpty)
    }
    
    func testLoadMoreAppendsToExistingArtworks() async {
        mockRepository.searchResult = .success(Array(1...40))
        mockRepository.fetchDetailResult = .success(createTestArtwork())
        
        await sut.fetchArtworks()
        XCTAssertEqual(sut.artworks.count, 20)
        
        await sut.loadMoreArtworks()
        XCTAssertEqual(sut.artworks.count, 40)
    }
    
    func testHasMorePagesReturnsFalseWhenAllLoaded() async {
        mockRepository.searchResult = .success([1, 2, 3])
        mockRepository.fetchDetailResult = .success(createTestArtwork())
        
        await sut.fetchArtworks()
        
        XCTAssertFalse(sut.hasMorePages)
    }
    
    func testLoadFromLocalStorageWithArtworksShowsMessage() async {
        let artworks = createTestArtworks(count: 3)
        mockRepository.loadLocalResult = .success(artworks)
        
        await sut.loadFromLocalStorage()
        
        XCTAssertEqual(sut.artworks.count, 3)
        XCTAssertEqual(sut.errorMessage, "Showing cached data.")
    }
    
    func testMultipleFetchArtworksResetsState() async {
        mockRepository.searchResult = .success(Array(1...30))
        mockRepository.fetchDetailResult = .success(createTestArtwork())
        
        await sut.fetchArtworks()
        await sut.loadMoreArtworks()
        XCTAssertEqual(sut.artworks.count, 30)
        
        mockRepository.searchResult = .success([1, 2])
        await sut.fetchArtworks()
        XCTAssertEqual(sut.artworks.count, 2)
    }
    
    func testFilteredArtworksEmptyWhenNoFavorites() {
        let artworks = [
            createTestArtwork(id: 1, isFavorite: false),
            createTestArtwork(id: 2, isFavorite: false)
        ]
        sut.artworks = artworks
        sut.filterFavorites = true
        
        XCTAssertTrue(sut.filteredArtworks.isEmpty)
    }
    
    func testSearchQueryTrimmed() async {
        sut.searchQuery = "  monet  "
        mockRepository.searchResult = .success([])
        
        await sut.fetchArtworks()
        
        XCTAssertEqual(mockRepository.lastSearchQuery, "  monet  ")
    }
    
    func testToggleFavoriteUpdatesRepository() async {
        let artwork = createTestArtwork(id: 5, isFavorite: false)
        sut.artworks = [artwork]
        
        await sut.toggleFavorite(for: artwork)
        
        XCTAssertEqual(mockRepository.updateFavoriteCallCount, 1)
        XCTAssertEqual(mockRepository.lastUpdatedArtworkId, 5)
    }
}
