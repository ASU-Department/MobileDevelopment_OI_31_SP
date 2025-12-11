import SwiftData

@Model
public final class FavoriteMovie {
    @Attribute(.unique) public var tmdbId: Int
    var userRating: Int = 0
    var comment: String = ""
    
    public init(tmdbId: Int) {
        self.tmdbId = tmdbId
    }
}
