import XCTest
@testable import ArtCurator

final class ArtworkDatabaseActorTests: XCTestCase {
    func testActorFetchAllArtworksThreadSafety() async {
        let expectation = XCTestExpectation(description: "Concurrent actor calls complete")
        expectation.expectedFulfillmentCount = 10
        
        for _ in 0..<10 {
            Task {
                expectation.fulfill()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    func testActorMethodsAreAsyncSafe() async {
        let iterations = 100
        var completionCount = 0
        
        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<iterations {
                group.addTask {
                    try? await Task.sleep(nanoseconds: UInt64.random(in: 1...1000))
                }
            }
            for await _ in group {
                completionCount += 1
            }
        }
        
        XCTAssertEqual(completionCount, iterations)
    }
}

final class MockRepositoryBehaviorTests: XCTestCase {
    var mockRepository: MockArtworkRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockArtworkRepository()
    }
    
    override func tearDown() {
        mockRepository = nil
        super.tearDown()
    }
    
    @MainActor
    func testSuccessfulSearch() async throws {
        mockRepository.searchResult = .success([1, 2, 3])
        
        let result = try await mockRepository.searchArtworks(query: "test")
        
        XCTAssertEqual(result, [1, 2, 3])
        XCTAssertEqual(mockRepository.searchCallCount, 1)
        XCTAssertEqual(mockRepository.lastSearchQuery, "test")
    }
    
    @MainActor
    func testFailedSearch() async {
        mockRepository.searchResult = .failure(MockError.networkError)
        
        do {
            _ = try await mockRepository.searchArtworks(query: "test")
            XCTFail("Expected error to be thrown")
        } catch let error as MockError {
            XCTAssertEqual(error, MockError.networkError)
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    @MainActor
    func testSuccessfulFetchDetail() async throws {
        let artwork = createTestArtwork(id: 42, title: "Test Art")
        mockRepository.fetchDetailResult = .success(artwork)
        
        let result = try await mockRepository.fetchArtworkDetail(objectID: 42)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.id, 42)
        XCTAssertEqual(result?.title, "Test Art")
    }
    
    @MainActor
    func testFetchDetailReturnsNil() async throws {
        mockRepository.fetchDetailResult = .success(nil)
        
        let result = try await mockRepository.fetchArtworkDetail(objectID: 1)
        
        XCTAssertNil(result)
    }
    
    @MainActor
    func testFetchDetailFailure() async {
        mockRepository.fetchDetailResult = .failure(MockError.notFound)
        
        do {
            _ = try await mockRepository.fetchArtworkDetail(objectID: 1)
            XCTFail("Expected error")
        } catch let error as MockError {
            XCTAssertEqual(error, MockError.notFound)
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    @MainActor
    func testLoadLocalArtworksSuccess() async throws {
        let artworks = createTestArtworks(count: 5)
        mockRepository.loadLocalResult = .success(artworks)
        
        let result = try await mockRepository.loadLocalArtworks()
        
        XCTAssertEqual(result.count, 5)
    }
    
    @MainActor
    func testLoadLocalArtworksEmpty() async throws {
        mockRepository.loadLocalResult = .success([])
        
        let result = try await mockRepository.loadLocalArtworks()
        
        XCTAssertTrue(result.isEmpty)
    }
    
    @MainActor
    func testLoadLocalArtworksFailure() async {
        mockRepository.loadLocalResult = .failure(MockError.databaseError)
        
        do {
            _ = try await mockRepository.loadLocalArtworks()
            XCTFail("Expected error")
        } catch let error as MockError {
            XCTAssertEqual(error, MockError.databaseError)
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    @MainActor
    func testSaveArtworksSuccess() async throws {
        let artworks = createTestArtworks(count: 3)
        
        try await mockRepository.saveArtworks(artworks)
        
        XCTAssertEqual(mockRepository.saveArtworksCallCount, 1)
        XCTAssertEqual(mockRepository.lastSavedArtworks?.count, 3)
    }
    
    @MainActor
    func testSaveArtworksFailure() async {
        mockRepository.saveArtworksError = MockError.databaseError
        
        do {
            try await mockRepository.saveArtworks([])
            XCTFail("Expected error")
        } catch let error as MockError {
            XCTAssertEqual(error, MockError.databaseError)
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    @MainActor
    func testUpdateFavoriteSuccess() async throws {
        try await mockRepository.updateFavorite(artworkId: 10, isFavorite: true)
        
        XCTAssertEqual(mockRepository.updateFavoriteCallCount, 1)
        XCTAssertEqual(mockRepository.lastUpdatedArtworkId, 10)
        XCTAssertEqual(mockRepository.lastUpdatedFavoriteStatus, true)
    }
    
    @MainActor
    func testUpdateFavoriteFailure() async {
        mockRepository.updateFavoriteError = MockError.databaseError
        
        do {
            try await mockRepository.updateFavorite(artworkId: 1, isFavorite: true)
            XCTFail("Expected error")
        } catch let error as MockError {
            XCTAssertEqual(error, MockError.databaseError)
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    @MainActor
    func testSearchWithDelay() async throws {
        mockRepository.searchResult = .success([1])
        mockRepository.searchDelay = 0.1
        
        let start = Date()
        _ = try await mockRepository.searchArtworks(query: "test")
        let elapsed = Date().timeIntervalSince(start)
        
        XCTAssertGreaterThanOrEqual(elapsed, 0.1)
    }
    
    @MainActor
    func testFetchDetailWithDelay() async throws {
        mockRepository.fetchDetailResult = .success(createTestArtwork())
        mockRepository.fetchDetailDelay = 0.1
        
        let start = Date()
        _ = try await mockRepository.fetchArtworkDetail(objectID: 1)
        let elapsed = Date().timeIntervalSince(start)
        
        XCTAssertGreaterThanOrEqual(elapsed, 0.1)
    }
    
    @MainActor
    func testResetClearsAllState() async throws {
        mockRepository.searchResult = .success([1])
        mockRepository.fetchDetailResult = .success(createTestArtwork())
        _ = try await mockRepository.searchArtworks(query: "test")
        _ = try await mockRepository.fetchArtworkDetail(objectID: 1)
        
        mockRepository.reset()
        
        XCTAssertEqual(mockRepository.searchCallCount, 0)
        XCTAssertEqual(mockRepository.fetchDetailCallCount, 0)
        XCTAssertNil(mockRepository.lastSearchQuery)
        XCTAssertNil(mockRepository.lastFetchedObjectID)
    }
    
    @MainActor
    func testConcurrentRepositoryCalls() async {
        mockRepository.searchResult = .success([1, 2, 3])
        mockRepository.fetchDetailResult = .success(createTestArtwork())
        
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<10 {
                group.addTask {
                    _ = try? await self.mockRepository.searchArtworks(query: "query\(i)")
                }
            }
        }
        
        XCTAssertEqual(mockRepository.searchCallCount, 10)
    }
    
    @MainActor
    func testCorruptedDataSimulation() async {
        mockRepository.fetchDetailResult = .failure(MockError.decodingError)
        
        do {
            _ = try await mockRepository.fetchArtworkDetail(objectID: 1)
            XCTFail("Expected decoding error")
        } catch let error as MockError {
            XCTAssertEqual(error, MockError.decodingError)
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    @MainActor
    func testTimeoutSimulation() async {
        mockRepository.searchResult = .failure(MockError.timeout)
        
        do {
            _ = try await mockRepository.searchArtworks(query: "test")
            XCTFail("Expected timeout error")
        } catch let error as MockError {
            XCTAssertEqual(error, MockError.timeout)
        } catch {
            XCTFail("Unexpected error type")
        }
    }
}

final class RepositoryEdgeCaseTests: XCTestCase {
    var mockRepository: MockArtworkRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockArtworkRepository()
    }
    
    override func tearDown() {
        mockRepository = nil
        super.tearDown()
    }
    
    @MainActor
    func testEmptyQuerySearch() async throws {
        mockRepository.searchResult = .success([])
        
        let result = try await mockRepository.searchArtworks(query: "")
        
        XCTAssertTrue(result.isEmpty)
        XCTAssertEqual(mockRepository.lastSearchQuery, "")
    }
    
    @MainActor
    func testSpecialCharactersInQuery() async throws {
        mockRepository.searchResult = .success([1])
        
        _ = try await mockRepository.searchArtworks(query: "L'Art & Design")
        
        XCTAssertEqual(mockRepository.lastSearchQuery, "L'Art & Design")
    }
    
    @MainActor
    func testUnicodeQuery() async throws {
        mockRepository.searchResult = .success([1])
        
        _ = try await mockRepository.searchArtworks(query: "日本画")
        
        XCTAssertEqual(mockRepository.lastSearchQuery, "日本画")
    }
    
    @MainActor
    func testFetchDetailWithZeroId() async throws {
        mockRepository.fetchDetailResult = .success(createTestArtwork(id: 0))
        
        let result = try await mockRepository.fetchArtworkDetail(objectID: 0)
        
        XCTAssertEqual(result?.id, 0)
        XCTAssertEqual(mockRepository.lastFetchedObjectID, 0)
    }
    
    @MainActor
    func testFetchDetailWithNegativeId() async throws {
        mockRepository.fetchDetailResult = .success(createTestArtwork(id: -1))
        
        let result = try await mockRepository.fetchArtworkDetail(objectID: -1)
        
        XCTAssertEqual(result?.id, -1)
        XCTAssertEqual(mockRepository.lastFetchedObjectID, -1)
    }
    
    @MainActor
    func testSaveEmptyArtworksArray() async throws {
        try await mockRepository.saveArtworks([])
        
        XCTAssertEqual(mockRepository.saveArtworksCallCount, 1)
        XCTAssertEqual(mockRepository.lastSavedArtworks?.count, 0)
    }
    
    @MainActor
    func testSaveLargeArtworksArray() async throws {
        let artworks = createTestArtworks(count: 100)
        
        try await mockRepository.saveArtworks(artworks)
        
        XCTAssertEqual(mockRepository.lastSavedArtworks?.count, 100)
    }
    
    @MainActor
    func testUpdateFavoriteWithZeroId() async throws {
        try await mockRepository.updateFavorite(artworkId: 0, isFavorite: true)
        
        XCTAssertEqual(mockRepository.lastUpdatedArtworkId, 0)
    }
    
    @MainActor
    func testUpdateFavoriteWithNegativeId() async throws {
        try await mockRepository.updateFavorite(artworkId: -1, isFavorite: true)
        
        XCTAssertEqual(mockRepository.lastUpdatedArtworkId, -1)
    }
    
    @MainActor
    func testMultipleSequentialFetchDetails() async throws {
        mockRepository.fetchDetailResult = .success(createTestArtwork())
        
        for i in 1...10 {
            _ = try await mockRepository.fetchArtworkDetail(objectID: i)
        }
        
        XCTAssertEqual(mockRepository.fetchDetailCallCount, 10)
        XCTAssertEqual(mockRepository.lastFetchedObjectID, 10)
    }
    
    @MainActor
    func testSearchResultWithLargeArray() async throws {
        let largeArray = Array(1...10000)
        mockRepository.searchResult = .success(largeArray)
        
        let result = try await mockRepository.searchArtworks(query: "test")
        
        XCTAssertEqual(result.count, 10000)
    }
    
    @MainActor
    func testLoadLocalWithDuplicateIds() async throws {
        let artworks = [
            createTestArtwork(id: 1, title: "First"),
            createTestArtwork(id: 1, title: "Duplicate")
        ]
        mockRepository.loadLocalResult = .success(artworks)
        
        let result = try await mockRepository.loadLocalArtworks()
        
        XCTAssertEqual(result.count, 2)
    }
    
    @MainActor
    func testMultipleErrorTypes() async {
        let errors: [MockError] = [.networkError, .decodingError, .databaseError, .timeout, .notFound]
        
        for error in errors {
            mockRepository.searchResult = .failure(error)
            
            do {
                _ = try await mockRepository.searchArtworks(query: "test")
                XCTFail("Expected error")
            } catch let caughtError as MockError {
                XCTAssertEqual(caughtError, error)
            } catch {
                XCTFail("Unexpected error type")
            }
        }
    }
    
    @MainActor
    func testSequentialUpdateFavoriteToggle() async throws {
        for i in 0..<5 {
            let isFavorite = i % 2 == 0
            try await mockRepository.updateFavorite(artworkId: 1, isFavorite: isFavorite)
            XCTAssertEqual(mockRepository.lastUpdatedFavoriteStatus, isFavorite)
        }
        
        XCTAssertEqual(mockRepository.updateFavoriteCallCount, 5)
    }
}
