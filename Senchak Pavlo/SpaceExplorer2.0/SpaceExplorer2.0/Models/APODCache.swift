import Foundation
import SwiftData

@Model
class CachedAPOD {
    @Attribute(.unique) var id: String
    var title: String
    var explanation: String
    var url: String
    var mediaType: String
    var savedAt: Date

    init(
        id: String = UUID().uuidString,
        title: String,
        explanation: String,
        url: String,
        mediaType: String,
        savedAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.explanation = explanation
        self.url = url
        self.mediaType = mediaType
        self.savedAt = savedAt
    }
}

extension CachedAPOD {
    func toResponse() -> APODResponse {
        APODResponse(
            title: title,
            explanation: explanation,
            url: url,
            media_type: mediaType
        )
    }
}

