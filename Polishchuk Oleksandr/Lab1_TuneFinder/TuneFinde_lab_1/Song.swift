import Foundation

struct Song: Identifiable, Codable, Equatable {
    let trackId: Int
    let trackName: String
    let artistName: String
    let artworkUrl100: URL?
    let previewUrl: URL?
    let collectionName: String?
    let primaryGenreName: String?
    let trackPrice: Double?
    let currency: String?

    var id: Int { trackId }

    enum CodingKeys: String, CodingKey {
        case trackId
        case trackName
        case artistName
        case artworkUrl100
        case previewUrl
        case collectionName
        case primaryGenreName
        case trackPrice
        case currency
    }

    init(
        trackId: Int,
        trackName: String,
        artistName: String,
        artworkUrl100: URL?,
        previewUrl: URL?,
        collectionName: String? = nil,
        primaryGenreName: String? = nil,
        trackPrice: Double? = nil,
        currency: String? = nil
    ) {
        self.trackId = trackId
        self.trackName = trackName
        self.artistName = artistName
        self.artworkUrl100 = artworkUrl100
        self.previewUrl = previewUrl
        self.collectionName = collectionName
        self.primaryGenreName = primaryGenreName
        self.trackPrice = trackPrice
        self.currency = currency
    }

    init(from entity: SongEntity) {
        self.init(
            trackId: entity.id,
            trackName: entity.trackName,
            artistName: entity.artistName,
            artworkUrl100: entity.artworkUrl100.flatMap(URL.init(string:)),
            previewUrl: entity.previewUrl.flatMap(URL.init(string:)),
            collectionName: entity.collectionName,
            primaryGenreName: entity.primaryGenreName,
            trackPrice: entity.trackPrice,
            currency: entity.currency
        )
    }

    init(from entity: FavoriteSongEntity) {
        self.init(
            trackId: entity.id,
            trackName: entity.trackName,
            artistName: entity.artistName,
            artworkUrl100: entity.artworkUrl100.flatMap(URL.init(string:)),
            previewUrl: entity.previewUrl.flatMap(URL.init(string:)),
            collectionName: entity.collectionName,
            primaryGenreName: entity.primaryGenreName,
            trackPrice: entity.trackPrice,
            currency: entity.currency
        )
    }
}
