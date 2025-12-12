import SwiftUI

struct DetailView: View {
    let movie: TMDBMovie
    @State private var viewModel: MovieDetailViewModel
    
    init(movie: TMDBMovie, favoriteRepository: FavoriteRepositoryProtocol){
        self.movie = movie
        _viewModel = State(initialValue: MovieDetailViewModel(
            movie: movie,
            favoriteRepository: favoriteRepository
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: viewModel.posterURL) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 400)
                
                Text(viewModel.title)
                    .font(.largeTitle)
                    .padding(.horizontal)
                
                Text(viewModel.overview)
                    .padding(.horizontal)
                
                Button(viewModel.isFavorite ? "В обраних" : "Додати в обране") {
                    viewModel.toggleFavorite()
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationTitle(viewModel.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
