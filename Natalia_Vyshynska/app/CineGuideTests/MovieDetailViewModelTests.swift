import Testing
@testable import app

@Suite("Movie Detail ViewModel Tests")
struct MovieDetailViewModelTests {
    let movie = TMDBMovie(
        id: 999,
        title: "Test Movie",
        overview: nil,
        poster_path: nil,
        vote_average: 7.5,
        release_date: nil
    )
    
    @Test("Initial favorite status is false when not in repository")
    func initialStatusNotFavorite() async {
        let mockRepository = MockFavoriteRepository()
        
        await MainActor.run {
            let viewModel = MovieDetailViewModel(movie: movie, favoriteRepository: mockRepository)
            
            Task {
                try? await Task.sleep(for: .milliseconds(200))
                #expect(viewModel.isFavorite == false)
            }
        }
    }
    
    @Test("Toggle favorite adds movie to repository")
    func toggleAddsFavorite() async {
        let mockRepository = MockFavoriteRepository()
        
        await MainActor.run {
            let viewModel = MovieDetailViewModel(movie: movie, favoriteRepository: mockRepository)
            
            viewModel.toggleFavorite()
            
            Task {
                try? await Task.sleep(for: .milliseconds(200))
                #expect(mockRepository.favoriteIDs.contains(999))
            }
        }
    }
}
