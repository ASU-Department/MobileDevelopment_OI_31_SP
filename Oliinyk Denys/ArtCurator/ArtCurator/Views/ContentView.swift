//
//  ContentView.swift
//  ArtCurator
//
//  Created by Denys Oliinyk on 05.11.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var artworkService = ArtworkService.shared
    @State private var searchQuery = ""
    @State private var filterFavorites = false
    
    private var filteredArtworks: [Artwork] {
        artworkService.artworks.filter { artwork in
            if filterFavorites && !artwork.isFavorite {
                return false
            }
            
            if !searchQuery.isEmpty {
                let query = searchQuery.lowercased()
                let matchesTitle = artwork.title.lowercased().contains(query)
                let matchesArtist = artwork.artistDisplayName.lowercased().contains(query)
                return matchesTitle || matchesArtist
            }
            
            return true
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchBar(searchQuery: $searchQuery, filterFavorites: $filterFavorites)
                
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredArtworks) { artwork in
                            if let index = artworkService.artworks.firstIndex(where: {
                                $0.id == artwork.id
                            }) {
                                NavigationLink(destination: ArtworkDetails(
                                    artwork: $artworkService.artworks[index])
                                ) {
                                    ArtworkItem(artwork: $artworkService.artworks[index])
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
            }
            .navigationTitle("Art Gallery")
        }
    }
}

#Preview {
    ContentView()
}
