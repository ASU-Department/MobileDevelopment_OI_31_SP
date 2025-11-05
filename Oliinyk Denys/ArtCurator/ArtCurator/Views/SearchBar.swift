//
//  SearchBar.swift
//  ArtCurator
//
//  Created by Denys Oliinyk on 05.11.2025.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchQuery: String
    @Binding var filterFavorites: Bool
    
    var body: some View {
        VStack {
            TextField("Search artist or title", text: $searchQuery)
                .padding(10)
                .background(.gray.opacity(0.2))
                .cornerRadius(8)
            
            Toggle("Filter Favorites", isOn: $filterFavorites)
        }
        .padding()
    }
}
