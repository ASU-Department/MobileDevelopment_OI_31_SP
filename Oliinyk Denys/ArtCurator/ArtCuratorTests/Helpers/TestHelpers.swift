import Foundation
@testable import ArtCurator

@MainActor
func createTestArtwork(
    id: Int = 1,
    title: String = "Test Artwork",
    artistDisplayName: String = "Test Artist",
    primaryImageSmall: String = "https://example.com/small.jpg",
    primaryImage: String = "https://example.com/large.jpg",
    objectDate: String = "2023",
    medium: String = "Oil on canvas",
    department: String = "Modern Art",
    isFavorite: Bool = false
) -> Artwork {
    let artwork = Artwork(
        id: id,
        title: title,
        artistDisplayName: artistDisplayName,
        primaryImageSmall: primaryImageSmall,
        primaryImage: primaryImage,
        objectDate: objectDate,
        medium: medium,
        department: department
    )
    artwork.isFavorite = isFavorite
    return artwork
}

@MainActor
func createTestArtworks(count: Int) -> [Artwork] {
    (1...count).map { index in
        createTestArtwork(
            id: index,
            title: "Artwork \(index)",
            artistDisplayName: "Artist \(index)",
            isFavorite: index % 2 == 0
        )
    }
}
