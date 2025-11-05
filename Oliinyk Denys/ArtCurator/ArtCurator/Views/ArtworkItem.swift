//
//  ArtworkItem.swift
//  ArtCurator
//
//  Created by Denys Oliinyk on 05.11.2025.
//

import SwiftUI

struct ArtworkItem: View {
    @Binding var artwork: Artwork
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(.blue.opacity(0.3))
                .frame(width: 60, height: 60)
                .cornerRadius(8)
                .padding(.trailing, 8)
            
            VStack(alignment: .leading) {
                Text(artwork.title)
                    .font(.headline)
                Text(artwork.artistDisplayName)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: { artwork.isFavorite.toggle() }) {
                Image(systemName: artwork.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(artwork.isFavorite ? .red : .gray)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.15))
        .cornerRadius(10)
    }
}
