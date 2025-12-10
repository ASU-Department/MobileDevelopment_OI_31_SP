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
        VStack(spacing: 12) {
            TextField("Search artist or title", text: $searchQuery)
                .padding(10)
                .background(.gray.opacity(0.2))
                .cornerRadius(8)
            
            Toggle("Filter Favorites", isOn: $filterFavorites)
                .toggleStyle(SwitchToggleStyle(tint: .red))
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
}
