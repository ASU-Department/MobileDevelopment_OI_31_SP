import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: MovieViewModel?

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
                                DetailView(movie: movie, viewModel: viewModel)
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
                let vm = MovieViewModel(modelContext: modelContext)
                await vm.loadMovies()
                self.viewModel = vm
            }
        }
    }
}
