import XCTest
@testable import app

final class MovieViewModelTests: XCTestCase {
    var viewModel: MovieViewModel!
    var mockRepository: MockFavoriteRepository!

    override func setUpWithError() throws {
        mockRepository = MockFavoriteRepository()
    }

    func testLoadMoviesSuccess() async {
        class SuccessTMDBService: TMDBService, @unchecked Sendable {
            override func fetchPopularMovies() async throws -> [TMDBMovie] {
                return [
                    TMDBMovie(id: 1, title: "Mock Movie", overview: nil, poster_path: nil, vote_average: 8.0, release_date: nil)
                ]
            }
        }
        
        await MainActor.run {
            self.viewModel = MovieViewModel(favoriteRepository: self.mockRepository)
            self.viewModel.tmdbService = SuccessTMDBService()
        }
        
        await viewModel.loadMovies()
        
        await MainActor.run {
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertNil(viewModel.errorMessage)
            XCTAssertGreaterThan(viewModel.movies.count, 0)
        }
    }
    
    func testLoadMoviesError() async {
        class ErrorTMDBService: TMDBService, @unchecked Sendable {
            override func fetchPopularMovies() async throws -> [TMDBMovie] {
                throw URLError(.badServerResponse)
            }
        }
        
        await MainActor.run {
            self.viewModel = MovieViewModel(favoriteRepository: self.mockRepository)
            self.viewModel.tmdbService = ErrorTMDBService()
        }
        
        await viewModel.loadMovies()
        
        await MainActor.run {
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertNotNil(viewModel.errorMessage)
        }
    }
    
    func testToggleFavorite() async {
        await MainActor.run {
            self.viewModel = MovieViewModel(favoriteRepository: self.mockRepository)
            self.viewModel.tmdbService = TMDBService()
        }
        
        let movie = TMDBMovie(
            id: 123,
            title: "Test",
            overview: nil,
            poster_path: nil,
            vote_average: 8.0,
            release_date: nil
        )
        
        await viewModel.toggleFavorite(movie)
        
        XCTAssertTrue(mockRepository.toggleCalledWith.contains(123))
        
        await MainActor.run {
            XCTAssertTrue(viewModel.favoriteIDs.contains(123))
        }
    }
}
