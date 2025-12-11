import Foundation

actor TMDBService {
    private let apiKey = "b80075191d4ca07dabffb55edf3c4b52"
    
    func fetchPopularMovies() async throws -> [TMDBMovie] {
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)&language=en-US&page=1"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 || httpResponse.statusCode == 7 {
            throw URLError(.userAuthenticationRequired)
        }
        
        let decoded = try JSONDecoder().decode(TMDBResponse.self, from: data)
        return decoded.results
    }
}
