import SwiftUI

struct MovieRow: View {
    let movie: TMDBMovie
    let viewModel: MovieViewModel
    
    var body: some View {
        HStack {
            AsyncImage(url: movie.posterURL) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFit()
                case .empty, .failure:
                    Color.gray.opacity(0.3)
                @unknown default:
                    Color.gray.opacity(0.3)
                }
            }
            .frame(width: 80, height: 120)
            .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(movie.title).font(.headline)
                Text("\(movie.vote_average, specifier: "%.1f") ★")
            }
            
            Spacer()
            
            Button {
                viewModel.toggleFavorite(movie)
            } label: {
                Image(systemName: viewModel.isFavorite(movie) ? "heart.fill" : "heart")
                    .foregroundColor(.red)
                    .font(.title2)
            }
            .accessibilityIdentifier(viewModel.isFavorite(movie) ? "heartFillButton" : "heartButton")
        }
        .padding(.vertical, 4)
    }
}
