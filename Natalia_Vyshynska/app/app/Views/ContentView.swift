import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.favoriteRepository) private var favoriteRepository: FavoriteRepositoryProtocol?
    @State private var viewModel: MovieViewModel? = nil
    
    var body: some View {
        NavigationStack {
            Group {
                if let repository = favoriteRepository, let viewModel = viewModel {
                    if viewModel.isLoading && viewModel.movies.isEmpty {
                        ProgressView("Завантажуємо фільми...")
                            .scaleEffect(1.5)
                    } else if let error = viewModel.errorMessage {
                        VStack(spacing: 20) {
                            Image(systemName: "wifi.slash")
                                .font(.system(size: 70))
                            Text(error)
                            Button("Спробувати ще") {
                                Task { await viewModel.loadMovies(forceRefresh: true) }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    } else {
                        List(viewModel.movies) { movie in
                            NavigationLink {
                                DetailView(
                                    movie: movie,
                                    favoriteRepository: repository)
                            } label: {
                                MovieRow(movie: movie, viewModel: viewModel)
                            }
                        }
                        .refreshable {
                            await viewModel.loadMovies(forceRefresh: true)
                        }
                    }
                } else {
                    ProgressView("Завантаження...")
                }
            }
            .navigationTitle("CineGuide")
            .task {
                if viewModel == nil, let repository = favoriteRepository {
                    viewModel = MovieViewModel(favoriteRepository: repository)
                    await viewModel?.loadMovies()
                }
            }
        }
    }
}
