import Foundation
import SwiftUI
import SwiftData

// TMDB
struct TMDBResponse: Codable {
    let results: [TMDBMovie]
}

struct TMDBMovie: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String?
    let poster_path: String?
    let vote_average: Double
    let release_date: String?
    
    var posterURL: URL? {
        guard let path = poster_path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}
