import Foundation

enum ITunesError: Error, LocalizedError {
    case badURL
    case networkError(Error)
    case decodingError(Error)
    case emptyResults

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "Failed to build request URL."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError:
            return "Failed to decode server response."
        case .emptyResults:
            return "No songs found for this query."
        }
    }
}

final class ITunesService {
    private let baseURL = "https://itunes.apple.com/search"

    func searchSongs(term: String) async throws -> [Song] {
        let trimmed = term.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw ITunesError.emptyResults
        }

        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "term", value: trimmed),
            URLQueryItem(name: "media", value: "music"),
            URLQueryItem(name: "entity", value: "song"),
            URLQueryItem(name: "limit", value: "25")
        ]

        guard let url = components?.url else {
            throw ITunesError.badURL
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            do {
                let decoded = try JSONDecoder().decode(ITunesResponse.self, from: data)
                guard !decoded.results.isEmpty else {
                    throw ITunesError.emptyResults
                }
                return decoded.results
            } catch {
                throw ITunesError.decodingError(error)
            }
        } catch {
            throw ITunesError.networkError(error)
        }
    }
}
	
