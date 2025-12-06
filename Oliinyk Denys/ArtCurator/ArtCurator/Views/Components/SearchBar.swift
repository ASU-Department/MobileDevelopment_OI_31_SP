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
    
    var isLoading = false
    var onSearch: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                TextField("Search artist or title", text: $searchQuery)
                    .padding(10)
                    .background(.gray.opacity(0.2))
                    .cornerRadius(8)
                    .onSubmit(onSearch)
                    .disabled(isLoading)
                
                Button(action: onSearch) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(isLoading ? Color.gray : Color.blue)
                        .cornerRadius(8)
                }
                .disabled(isLoading)
            }
            
            Toggle("Filter Favorites", isOn: $filterFavorites)
                .toggleStyle(SwitchToggleStyle(tint: .red))
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
}
