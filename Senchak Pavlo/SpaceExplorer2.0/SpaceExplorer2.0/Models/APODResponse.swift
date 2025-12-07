import Foundation

struct APODResponse: Codable, Hashable {
    let title: String
    let explanation: String
    let url: String
    let media_type: String
}
