//
//  ArtworkService.swift
//  ArtCurator
//
//  Created by Denys Oliinyk on 08.11.2025.
//

import Combine

class ArtworkService: ObservableObject {
    static let shared = ArtworkService()
    
    @Published var artworks: [Artwork] = []
    
    func loadMockData() {
        artworks = [
            Artwork(id: 1, title: "Some Artwork 1", artistDisplayName: "Some Artist 1"),
            Artwork(id: 2, title: "Some Artwork 2", artistDisplayName: "Some Artist 2"),
            Artwork(id: 3, title: "Some Artwork 3", artistDisplayName: "Some Artist 3"),
            Artwork(id: 4, title: "Some Artwork 4", artistDisplayName: "Some Artist 4"),
            Artwork(id: 5, title: "Some Artwork 5", artistDisplayName: "Some Artist 5"),
            Artwork(id: 6, title: "Some Artwork 6", artistDisplayName: "Some Artist 6"),
            Artwork(id: 7, title: "Some Artwork 7", artistDisplayName: "Some Artist 7")
        ]
    }
}
