//
//  ContentView.swift
//  ArtCurator
//
//  Created by Denys Oliinyk on 05.11.2025.
//

import SwiftUI

struct ContentView: View {
    @State private var searchQuery = ""
    @State private var filterFavorites = false
    @State private var artworks = [
        Artwork(id: 1, title: "Some Artwork 1", artistDisplayName: "Some Artist 1"),
        Artwork(id: 2, title: "Some Artwork 2", artistDisplayName: "Some Artist 2"),
        Artwork(id: 3, title: "Some Artwork 3", artistDisplayName: "Some Artist 3"),
        Artwork(id: 4, title: "Some Artwork 4", artistDisplayName: "Some Artist 4"),
        Artwork(id: 5, title: "Some Artwork 5", artistDisplayName: "Some Artist 5"),
        Artwork(id: 6, title: "Some Artwork 6", artistDisplayName: "Some Artist 6"),
        Artwork(id: 7, title: "Some Artwork 7", artistDisplayName: "Some Artist 7")
    ]
    
    private var filteredArtworks: [Binding<Artwork>] {
        $artworks.filter { $artwork in
            let artwork = $artwork.wrappedValue
            
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
        NavigationView {
            VStack {
                SearchBar(searchQuery: $searchQuery, filterFavorites: $filterFavorites)
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(filteredArtworks) { artwork in
                            ArtworkItem(artwork: artwork)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("ArtCurator Gallery")
        }
    }
}

#Preview {
    ContentView()
}
