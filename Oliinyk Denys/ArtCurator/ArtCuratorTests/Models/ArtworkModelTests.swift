import XCTest
@testable import ArtCurator

@MainActor
final class ArtworkModelTests: XCTestCase {
    
    func testArtworkInitialization() {
        let artwork = Artwork(
            id: 1,
            title: "Starry Night",
            artistDisplayName: "Van Gogh",
            primaryImageSmall: "small.jpg",
            primaryImage: "large.jpg",
            objectDate: "1889",
            medium: "Oil on canvas",
            department: "Modern Art"
        )
        
        XCTAssertEqual(artwork.id, 1)
        XCTAssertEqual(artwork.title, "Starry Night")
        XCTAssertEqual(artwork.artistDisplayName, "Van Gogh")
        XCTAssertEqual(artwork.primaryImageSmall, "small.jpg")
        XCTAssertEqual(artwork.primaryImage, "large.jpg")
        XCTAssertEqual(artwork.objectDate, "1889")
        XCTAssertEqual(artwork.medium, "Oil on canvas")
        XCTAssertEqual(artwork.department, "Modern Art")
        XCTAssertFalse(artwork.isFavorite)
    }
    
    func testArtworkDefaultValues() {
        let artwork = Artwork(
            id: 1,
            title: "Test",
            artistDisplayName: "Artist"
        )
        
        XCTAssertEqual(artwork.primaryImageSmall, "")
        XCTAssertEqual(artwork.primaryImage, "")
        XCTAssertEqual(artwork.objectDate, "")
        XCTAssertEqual(artwork.medium, "")
        XCTAssertEqual(artwork.department, "")
        XCTAssertFalse(artwork.isFavorite)
    }
    
    func testArtworkIsFavoriteToggle() {
        let artwork = Artwork(id: 1, title: "Test", artistDisplayName: "Artist")
        
        XCTAssertFalse(artwork.isFavorite)
        
        artwork.isFavorite = true
        XCTAssertTrue(artwork.isFavorite)
        
        artwork.isFavorite = false
        XCTAssertFalse(artwork.isFavorite)
    }
    
    func testArtworkIdentifiable() {
        let artwork1 = Artwork(id: 1, title: "Art 1", artistDisplayName: "Artist 1")
        let artwork2 = Artwork(id: 2, title: "Art 2", artistDisplayName: "Artist 2")
        
        XCTAssertEqual(artwork1.id, 1)
        XCTAssertEqual(artwork2.id, 2)
        XCTAssertNotEqual(artwork1.id, artwork2.id)
    }
    
    func testArtworkWithEmptyStrings() {
        let artwork = Artwork(
            id: 0,
            title: "",
            artistDisplayName: "",
            primaryImageSmall: "",
            primaryImage: "",
            objectDate: "",
            medium: "",
            department: ""
        )
        
        XCTAssertEqual(artwork.id, 0)
        XCTAssertEqual(artwork.title, "")
        XCTAssertEqual(artwork.artistDisplayName, "")
    }
    
    func testArtworkWithSpecialCharacters() {
        let artwork = Artwork(
            id: 1,
            title: "L'Été & L'Hiver",
            artistDisplayName: "José García",
            objectDate: "c. 1900–1905"
        )
        
        XCTAssertEqual(artwork.title, "L'Été & L'Hiver")
        XCTAssertEqual(artwork.artistDisplayName, "José García")
        XCTAssertEqual(artwork.objectDate, "c. 1900–1905")
    }
    
    func testArtworkWithLongStrings() {
        let longTitle = String(repeating: "A", count: 1000)
        let longArtist = String(repeating: "B", count: 1000)
        
        let artwork = Artwork(
            id: 1,
            title: longTitle,
            artistDisplayName: longArtist
        )
        
        XCTAssertEqual(artwork.title.count, 1000)
        XCTAssertEqual(artwork.artistDisplayName.count, 1000)
    }
    
    func testArtworkWithUnicodeCharacters() {
        let artwork = Artwork(
            id: 1,
            title: "日本画",
            artistDisplayName: "北斎"
        )
        
        XCTAssertEqual(artwork.title, "日本画")
        XCTAssertEqual(artwork.artistDisplayName, "北斎")
    }
    
    func testArtworkMutation() {
        let artwork = Artwork(id: 1, title: "Original", artistDisplayName: "Artist")
        
        artwork.title = "Modified"
        artwork.artistDisplayName = "New Artist"
        artwork.medium = "Watercolor"
        
        XCTAssertEqual(artwork.title, "Modified")
        XCTAssertEqual(artwork.artistDisplayName, "New Artist")
        XCTAssertEqual(artwork.medium, "Watercolor")
    }
    
    func testArtworkWithURLStrings() {
        let artwork = Artwork(
            id: 1,
            title: "Test",
            artistDisplayName: "Artist",
            primaryImageSmall: "https://example.com/small.jpg",
            primaryImage: "https://example.com/large.jpg"
        )
        
        XCTAssertTrue(artwork.primaryImageSmall.hasPrefix("https://"))
        XCTAssertTrue(artwork.primaryImage.hasPrefix("https://"))
    }
    
    func testArtworkNegativeId() {
        let artwork = Artwork(id: -1, title: "Test", artistDisplayName: "Artist")
        
        XCTAssertEqual(artwork.id, -1)
    }
    
    func testArtworkLargeId() {
        let artwork = Artwork(id: Int.max, title: "Test", artistDisplayName: "Artist")
        
        XCTAssertEqual(artwork.id, Int.max)
    }
}

final class ArtworkSearchResponseTests: XCTestCase {
    
    func testDecodeSearchResponseWithResults() throws {
        let json = """
        {
            "total": 3,
            "objectIDs": [1, 2, 3]
        }
        """
        let data = json.data(using: .utf8)!
        
        let response = try JSONDecoder().decode(ArtworkSearchResponse.self, from: data)
        
        XCTAssertEqual(response.total, 3)
        XCTAssertEqual(response.objectIDs, [1, 2, 3])
    }
    
    func testDecodeSearchResponseWithNullObjectIDs() throws {
        let json = """
        {
            "total": 0,
            "objectIDs": null
        }
        """
        let data = json.data(using: .utf8)!
        
        let response = try JSONDecoder().decode(ArtworkSearchResponse.self, from: data)
        
        XCTAssertEqual(response.total, 0)
        XCTAssertNil(response.objectIDs)
    }
    
    func testDecodeSearchResponseEmptyArray() throws {
        let json = """
        {
            "total": 0,
            "objectIDs": []
        }
        """
        let data = json.data(using: .utf8)!
        
        let response = try JSONDecoder().decode(ArtworkSearchResponse.self, from: data)
        
        XCTAssertEqual(response.total, 0)
        XCTAssertEqual(response.objectIDs, [])
    }
    
    func testDecodeSearchResponseLargeTotal() throws {
        let json = """
        {
            "total": 999999,
            "objectIDs": [1]
        }
        """
        let data = json.data(using: .utf8)!
        
        let response = try JSONDecoder().decode(ArtworkSearchResponse.self, from: data)
        
        XCTAssertEqual(response.total, 999999)
    }
}

final class ArtworkObjectResponseTests: XCTestCase {
    
    func testDecodeObjectResponse() throws {
        let json = """
        {
            "objectID": 123,
            "title": "Mona Lisa",
            "artistDisplayName": "Leonardo da Vinci",
            "primaryImageSmall": "https://example.com/small.jpg",
            "primaryImage": "https://example.com/large.jpg",
            "objectDate": "1503-1519",
            "medium": "Oil on poplar",
            "department": "Paintings"
        }
        """
        let data = json.data(using: .utf8)!
        
        let response = try JSONDecoder().decode(ArtworkObjectResponse.self, from: data)
        
        XCTAssertEqual(response.objectID, 123)
        XCTAssertEqual(response.title, "Mona Lisa")
        XCTAssertEqual(response.artistDisplayName, "Leonardo da Vinci")
        XCTAssertEqual(response.primaryImageSmall, "https://example.com/small.jpg")
        XCTAssertEqual(response.primaryImage, "https://example.com/large.jpg")
        XCTAssertEqual(response.objectDate, "1503-1519")
        XCTAssertEqual(response.medium, "Oil on poplar")
        XCTAssertEqual(response.department, "Paintings")
    }
    
    func testDecodeObjectResponseWithEmptyStrings() throws {
        let json = """
        {
            "objectID": 1,
            "title": "",
            "artistDisplayName": "",
            "primaryImageSmall": "",
            "primaryImage": "",
            "objectDate": "",
            "medium": "",
            "department": ""
        }
        """
        let data = json.data(using: .utf8)!
        
        let response = try JSONDecoder().decode(ArtworkObjectResponse.self, from: data)
        
        XCTAssertEqual(response.objectID, 1)
        XCTAssertEqual(response.title, "")
        XCTAssertEqual(response.artistDisplayName, "")
    }
    
    func testDecodeObjectResponseWithSpecialCharacters() throws {
        let json = """
        {
            "objectID": 1,
            "title": "L'Été",
            "artistDisplayName": "José García",
            "primaryImageSmall": "",
            "primaryImage": "",
            "objectDate": "c. 1900–1905",
            "medium": "Oil & tempera",
            "department": "European"
        }
        """
        let data = json.data(using: .utf8)!
        
        let response = try JSONDecoder().decode(ArtworkObjectResponse.self, from: data)
        
        XCTAssertEqual(response.title, "L'Été")
        XCTAssertEqual(response.artistDisplayName, "José García")
    }
}
