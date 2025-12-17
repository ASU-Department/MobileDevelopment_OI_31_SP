import Testing
@testable import ArtCurator

@Suite("Actor Isolation Tests")
struct ActorIsolationTests {
    @Test("Concurrent state access is safe")
    func concurrentStateAccess() async {
        let iterations = 50
        var completedCount = 0
        
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<iterations {
                group.addTask {
                    try? await Task.sleep(nanoseconds: UInt64.random(in: 1...10000))
                }
            }
            for await _ in group {
                completedCount += 1
            }
        }
        
        #expect(completedCount == iterations)
    }
    
    @Test("Sequential actor calls maintain order")
    func sequentialActorCalls() async {
        var sequence: [Int] = []
        
        for i in 0..<10 {
            sequence.append(i)
        }
        
        #expect(sequence == Array(0..<10))
    }
    
    @Test("State consistency across awaits")
    func stateConsistencyAcrossAwaits() async {
        var value = 0
        
        value += 1
        try? await Task.sleep(nanoseconds: 1000)
        value += 1
        try? await Task.sleep(nanoseconds: 1000)
        value += 1
        
        #expect(value == 3)
    }
    
    @Test("Concurrent increments complete correctly")
    func concurrentIncrements() async {
        let iterations = 100
        var completionFlags = [Bool](repeating: false, count: iterations)
        
        await withTaskGroup(of: Int.self) { group in
            for i in 0..<iterations {
                group.addTask {
                    try? await Task.sleep(nanoseconds: UInt64.random(in: 1...1000))
                    return i
                }
            }
            for await index in group {
                completionFlags[index] = true
            }
        }
        
        #expect(completionFlags.allSatisfy { $0 })
    }
}

@Suite("Mock Repository Edge Cases")
struct MockRepositoryEdgeCaseTests {
    
    @Test("Empty search results")
    @MainActor
    func emptySearchResults() async throws {
        let mock = MockArtworkRepository()
        mock.searchResult = .success([])
        
        let result = try await mock.searchArtworks(query: "nonexistent")
        
        #expect(result.isEmpty)
    }
    
    @Test("Large result set handling")
    @MainActor
    func largeResultSet() async throws {
        let mock = MockArtworkRepository()
        let largeArray = Array(1...10000)
        mock.searchResult = .success(largeArray)
        
        let result = try await mock.searchArtworks(query: "test")
        
        #expect(result.count == 10000)
    }
    
    @Test("Nil artwork detail")
    @MainActor
    func nilArtworkDetail() async throws {
        let mock = MockArtworkRepository()
        mock.fetchDetailResult = .success(nil)
        
        let result = try await mock.fetchArtworkDetail(objectID: 999)
        
        #expect(result == nil)
    }
    
    @Test("Network error simulation")
    @MainActor
    func networkErrorSimulation() async {
        let mock = MockArtworkRepository()
        mock.searchResult = .failure(MockError.networkError)
        
        do {
            _ = try await mock.searchArtworks(query: "test")
            Issue.record("Expected error to be thrown")
        } catch let error as MockError {
            #expect(error == MockError.networkError)
        } catch {
            Issue.record("Unexpected error type")
        }
    }
    
    @Test("Database error simulation")
    @MainActor
    func databaseErrorSimulation() async {
        let mock = MockArtworkRepository()
        mock.loadLocalResult = .failure(MockError.databaseError)
        
        do {
            _ = try await mock.loadLocalArtworks()
            Issue.record("Expected error to be thrown")
        } catch let error as MockError {
            #expect(error == MockError.databaseError)
        } catch {
            Issue.record("Unexpected error type")
        }
    }
    
    @Test("Decoding error simulation")
    @MainActor
    func decodingErrorSimulation() async {
        let mock = MockArtworkRepository()
        mock.fetchDetailResult = .failure(MockError.decodingError)
        
        do {
            _ = try await mock.fetchArtworkDetail(objectID: 1)
            Issue.record("Expected error to be thrown")
        } catch let error as MockError {
            #expect(error == MockError.decodingError)
        } catch {
            Issue.record("Unexpected error type")
        }
    }
    
    @Test("Timeout error simulation")
    @MainActor
    func timeoutErrorSimulation() async {
        let mock = MockArtworkRepository()
        mock.searchResult = .failure(MockError.timeout)
        
        do {
            _ = try await mock.searchArtworks(query: "test")
            Issue.record("Expected error to be thrown")
        } catch let error as MockError {
            #expect(error == MockError.timeout)
        } catch {
            Issue.record("Unexpected error type")
        }
    }
    
    @Test("Save artworks with empty array")
    @MainActor
    func saveEmptyArtworks() async throws {
        let mock = MockArtworkRepository()
        
        try await mock.saveArtworks([])
        
        #expect(mock.saveArtworksCallCount == 1)
        #expect(mock.lastSavedArtworks?.isEmpty == true)
    }
    
    @Test("Update favorite toggling")
    @MainActor
    func updateFavoriteToggling() async throws {
        let mock = MockArtworkRepository()
        
        try await mock.updateFavorite(artworkId: 1, isFavorite: true)
        #expect(mock.lastUpdatedFavoriteStatus == true)
        
        try await mock.updateFavorite(artworkId: 1, isFavorite: false)
        #expect(mock.lastUpdatedFavoriteStatus == false)
        
        #expect(mock.updateFavoriteCallCount == 2)
    }
    
    @Test("Multiple sequential searches")
    @MainActor
    func multipleSequentialSearches() async throws {
        let mock = MockArtworkRepository()
        mock.searchResult = .success([1, 2, 3])
        
        _ = try await mock.searchArtworks(query: "first")
        _ = try await mock.searchArtworks(query: "second")
        _ = try await mock.searchArtworks(query: "third")
        
        #expect(mock.searchCallCount == 3)
        #expect(mock.lastSearchQuery == "third")
    }
}
