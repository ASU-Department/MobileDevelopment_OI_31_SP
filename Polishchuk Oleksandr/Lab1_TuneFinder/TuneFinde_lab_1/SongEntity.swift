import Foundation
import SwiftData

@Model
final class SongEntity {
    @Attribute(.unique) var id: Int
    var trackName: String
    var artistName: String
    var artworkUrl100: String?
    var previewUrl: String?
    var collectionName: String?
    var primaryGenreName: String?
    var trackPrice: Double?
    var currency: String?
    var savedAt: Date

    init(
        id: Int,
        trackName: String,
        artistName: String,
        artworkUrl100: String?,
        previewUrl: String?,
        collectionName: String?,
        primaryGenreName: String?,
        trackPrice: Double?,
        currency: String?
    ) {
        self.id = id
        self.trackName = trackName
        self.artistName = artistName
        self.artworkUrl100 = artworkUrl100
        self.previewUrl = previewUrl
        self.collectionName = collectionName
        self.primaryGenreName = primaryGenreName
        self.trackPrice = trackPrice
        self.currency = currency
        self.savedAt = Date()
    }

    convenience init(from song: Song) {
        self.init(
            id: song.id,
            trackName: song.trackName,
            artistName: song.artistName,
            artworkUrl100: song.artworkUrl100?.absoluteString,
            previewUrl: song.previewUrl?.absoluteString,
            collectionName: song.collectionName,
            primaryGenreName: song.primaryGenreName,
            trackPrice: song.trackPrice,
            currency: song.currency
        )
    }

    func toSong() -> Song {
        Song(
            trackId: id,
            trackName: trackName,
            artistName: artistName,
            artworkUrl100: artworkUrl100.flatMap(URL.init(string:)),
            previewUrl: previewUrl.flatMap(URL.init(string:)),
            collectionName: collectionName,
            primaryGenreName: primaryGenreName,
            trackPrice: trackPrice,
            currency: currency
        )
    }
}
