import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.favoriteRepository) private var favoriteRepository
    @State private var viewModel: MovieViewModel? = nil
    var body: some View {
            NavigationStack {
                Group {
                    if let viewModel = viewModel {
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
                                    favoriteRepository: favoriteRepository)
                            } label: {
                                MovieRow(movie: movie, viewModel: viewModel)
                            }
                        }
                        .refreshable {
                            await viewModel.loadMovies(forceRefresh: true)
                        }
                    }
                } else {
                    ProgressView()
                }
            }
            .navigationTitle("CineGuide")
            .task {
                if viewModel == nil{
                    viewModel = MovieViewModel(favoriteRepository: favoriteRepository)
                    await viewModel?.loadMovies()
                }
            }
        }
    }
}
