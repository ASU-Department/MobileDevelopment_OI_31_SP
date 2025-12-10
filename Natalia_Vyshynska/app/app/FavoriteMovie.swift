import SwiftData

@Model
final class FavoriteMovie {
    @Attribute(.unique) var tmdbId: Int
    var userRating: Int = 0
    var comment: String = ""
    
    init(tmdbId: Int) {
        self.tmdbId = tmdbId
    }
}
