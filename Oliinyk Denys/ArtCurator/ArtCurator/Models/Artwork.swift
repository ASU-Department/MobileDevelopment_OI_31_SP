//
//  Artwork.swift
//  ArtCurator
//
//  Created by Denys Oliinyk on 05.11.2025.
//

import Foundation

struct Artwork: Identifiable {
    let id: Int
    let title: String
    let artistDisplayName: String
    let primaryImageSmall = ""
    var isFavorite = false
}
