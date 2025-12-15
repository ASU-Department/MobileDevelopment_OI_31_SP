//
//  Artwork.swift
//  ArtCurator
//
//  Created by Denys Oliinyk on 05.11.2025.
//

import Foundation
import SwiftData

@Model
final class Artwork: Identifiable {
    @Attribute(.unique) var id: Int
    var title: String
    var artistDisplayName: String
    var primaryImageSmall: String
    var primaryImage: String
    var objectDate: String
    var medium: String
    var department: String
    var isFavorite = false
    
    init(
        id: Int,
        title: String,
        artistDisplayName: String,
        primaryImageSmall: String = "",
        primaryImage: String = "",
        objectDate: String = "",
        medium: String = "",
        department: String = ""
    ) {
        self.id = id
        self.title = title
        self.artistDisplayName = artistDisplayName
        self.primaryImageSmall = primaryImageSmall
        self.primaryImage = primaryImage
        self.objectDate = objectDate
        self.medium = medium
        self.department = department
    }
}

struct ArtworkSearchResponse: Codable {
    let total: Int
    let objectIDs: [Int]?
}

struct ArtworkObjectResponse: Codable {
    let objectID: Int
    let title: String
    let artistDisplayName: String
    let primaryImageSmall: String
    let primaryImage: String
    let objectDate: String
    let medium: String
    let department: String
}
