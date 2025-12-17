import Foundation

struct ITunesResponse: Codable {
    let resultCount: Int
    let results: [Song]
}
