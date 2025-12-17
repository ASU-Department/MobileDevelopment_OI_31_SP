import Testing
@testable import ArtCurator

@MainActor
@Suite("ArtworkDetailViewModel Tests")
struct ArtworkDetailViewModelSwiftTests {
    @Test("Initial state reflects provided artwork")
    func initialState() {
        let artwork = createTestArtwork(id: 1, title: "Test", artistDisplayName: "Artist")
        let mockRepository = MockArtworkRepository()
        let viewModel = ArtworkDetailViewModel(artwork: artwork, repository: mockRepository)
        
        #expect(viewModel.artwork.id == 1)
        #expect(viewModel.artwork.title == "Test")
        #expect(viewModel.artwork.artistDisplayName == "Artist")
    }
    
    @Test("Toggle favorite changes artwork state")
    func toggleFavoriteChangesState() async {
        let artwork = createTestArtwork(id: 1, isFavorite: false)
        let mockRepository = MockArtworkRepository()
        let viewModel = ArtworkDetailViewModel(artwork: artwork, repository: mockRepository)
        
        await viewModel.toggleFavorite()
        
        #expect(viewModel.artwork.isFavorite == true)
    }
    
    @Test("Toggle favorite calls repository")
    func toggleFavoriteCallsRepository() async {
        let artwork = createTestArtwork(id: 42, isFavorite: false)
        let mockRepository = MockArtworkRepository()
        let viewModel = ArtworkDetailViewModel(artwork: artwork, repository: mockRepository)
        
        await viewModel.toggleFavorite()
        
        #expect(mockRepository.updateFavoriteCallCount == 1)
        #expect(mockRepository.lastUpdatedArtworkId == 42)
        #expect(mockRepository.lastUpdatedFavoriteStatus == true)
    }
    
    @Test("Toggle favorite from true to false")
    func toggleFavoriteFromTrueToFalse() async {
        let artwork = createTestArtwork(id: 1, isFavorite: true)
        let mockRepository = MockArtworkRepository()
        let viewModel = ArtworkDetailViewModel(artwork: artwork, repository: mockRepository)
        
        await viewModel.toggleFavorite()
        
        #expect(viewModel.artwork.isFavorite == false)
        #expect(mockRepository.lastUpdatedFavoriteStatus == false)
    }
    
    @Test("Share text contains title and artist")
    func shareTextContainsTitleAndArtist() {
        let artwork = createTestArtwork(title: "Starry Night", artistDisplayName: "Van Gogh")
        let mockRepository = MockArtworkRepository()
        let viewModel = ArtworkDetailViewModel(artwork: artwork, repository: mockRepository)
        
        #expect(viewModel.shareText.contains("Starry Night"))
        #expect(viewModel.shareText.contains("Van Gogh"))
    }
    
    @Test("Share text format is correct")
    func shareTextFormat() {
        let artwork = createTestArtwork(title: "Title", artistDisplayName: "Artist")
        let mockRepository = MockArtworkRepository()
        let viewModel = ArtworkDetailViewModel(artwork: artwork, repository: mockRepository)
        
        #expect(viewModel.shareText == "Title by Artist")
    }
    
    @Test("Image URL returns primary image when available")
    func imageURLReturnsPrimaryImage() {
        let artwork = createTestArtwork(
            primaryImageSmall: "small.jpg",
            primaryImage: "large.jpg"
        )
        let mockRepository = MockArtworkRepository()
        let viewModel = ArtworkDetailViewModel(artwork: artwork, repository: mockRepository)
        
        #expect(viewModel.imageURL == "large.jpg")
    }
    
    @Test("Image URL falls back to small image when primary is empty")
    func imageURLFallsBackToSmall() {
        let artwork = createTestArtwork(
            primaryImageSmall: "small.jpg",
            primaryImage: ""
        )
        let mockRepository = MockArtworkRepository()
        let viewModel = ArtworkDetailViewModel(artwork: artwork, repository: mockRepository)
        
        #expect(viewModel.imageURL == "small.jpg")
    }
    
    @Test("Image URL returns empty when both are empty")
    func imageURLReturnsEmptyWhenBothEmpty() {
        let artwork = createTestArtwork(
            primaryImageSmall: "",
            primaryImage: ""
        )
        let mockRepository = MockArtworkRepository()
        let viewModel = ArtworkDetailViewModel(artwork: artwork, repository: mockRepository)
        
        #expect(viewModel.imageURL == "")
    }
    
    @Test("Toggle favorite handles repository error gracefully")
    func toggleFavoriteHandlesError() async {
        let artwork = createTestArtwork(id: 1, isFavorite: false)
        let mockRepository = MockArtworkRepository()
        mockRepository.updateFavoriteError = MockError.databaseError
        let viewModel = ArtworkDetailViewModel(artwork: artwork, repository: mockRepository)
        
        await viewModel.toggleFavorite()
        
        #expect(viewModel.artwork.isFavorite == true)
    }
    
    @Test("Multiple toggle favorites work correctly")
    func multipleToggleFavorites() async {
        let artwork = createTestArtwork(id: 1, isFavorite: false)
        let mockRepository = MockArtworkRepository()
        let viewModel = ArtworkDetailViewModel(artwork: artwork, repository: mockRepository)
        
        await viewModel.toggleFavorite()
        #expect(viewModel.artwork.isFavorite == true)
        
        await viewModel.toggleFavorite()
        #expect(viewModel.artwork.isFavorite == false)
        
        await viewModel.toggleFavorite()
        #expect(viewModel.artwork.isFavorite == true)
        
        #expect(mockRepository.updateFavoriteCallCount == 3)
    }
    
    @Test("Artwork properties are accessible")
    func artworkPropertiesAccessible() {
        let artwork = createTestArtwork(
            id: 100,
            title: "The Persistence of Memory",
            artistDisplayName: "Salvador Dalí",
            objectDate: "1931",
            medium: "Oil on canvas",
            department: "Painting and Sculpture"
        )
        let mockRepository = MockArtworkRepository()
        let viewModel = ArtworkDetailViewModel(artwork: artwork, repository: mockRepository)
        
        #expect(viewModel.artwork.id == 100)
        #expect(viewModel.artwork.title == "The Persistence of Memory")
        #expect(viewModel.artwork.artistDisplayName == "Salvador Dalí")
        #expect(viewModel.artwork.objectDate == "1931")
        #expect(viewModel.artwork.medium == "Oil on canvas")
        #expect(viewModel.artwork.department == "Painting and Sculpture")
    }
}
