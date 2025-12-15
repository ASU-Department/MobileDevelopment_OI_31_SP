//
//  ArtworkDetailViewModel.swift
//  ArtCurator
//
//  Created by Denys Oliinyk on 11.12.2025.
//

import Foundation
import Combine

@MainActor
class ArtworkDetailViewModel: ObservableObject {
    @Published var artwork: Artwork
    
    private let repository: ArtworkRepositoryProtocol
    
    init(artwork: Artwork, repository: ArtworkRepositoryProtocol) {
        self.artwork = artwork
        self.repository = repository
    }
    
    func toggleFavorite() async {
        artwork.isFavorite.toggle()
        try? await repository.updateFavorite(artworkId: artwork.id, isFavorite: artwork.isFavorite)
    }
    
    var shareText: String {
        "\(artwork.title) by \(artwork.artistDisplayName)"
    }
    
    var imageURL: String {
        artwork.primaryImage.isEmpty ? artwork.primaryImageSmall : artwork.primaryImage
    }
}
