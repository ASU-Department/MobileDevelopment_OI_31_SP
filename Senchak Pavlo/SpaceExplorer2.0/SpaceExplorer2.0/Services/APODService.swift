import Foundation

class APODService {
    private let apiKey = "W43aXnOXgYF25FBRlIibfLrUrKbUXCLgUb8jwFNg"

    func fetchAPOD() async throws -> APODResponse {
        let urlString = "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(APODResponse.self, from: data)
    }
}
