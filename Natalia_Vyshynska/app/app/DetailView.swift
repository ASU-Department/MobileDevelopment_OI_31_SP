import SwiftUI

struct DetailView: View {
    let movie: TMDBMovie
    let viewModel: MovieViewModel
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                AsyncImage(url: movie.posterURL) { $0.resizable().scaledToFit() } placeholder: { ProgressView() }
                    .frame(height: 400)
                
                Text(movie.title).font(.largeTitle).padding()
                Text(movie.overview ?? "Немає опису").padding()
                
                Button("\(viewModel.isFavorite(movie) ? "В обраних" : "Додати в обране")") {
                    viewModel.toggleFavorite(movie)
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
