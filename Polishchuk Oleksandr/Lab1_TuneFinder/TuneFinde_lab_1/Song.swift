import Foundation

struct Song: Identifiable, Codable, Equatable {
    let id: Int
    let trackName: String
    let artistName: String
    let artworkUrl100: String?
    let previewUrl: String?
    let collectionName: String?
    let trackViewUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "trackId"
        case trackName
        case artistName
        case artworkUrl100
        case previewUrl
        case collectionName
        case trackViewUrl
    }
}
