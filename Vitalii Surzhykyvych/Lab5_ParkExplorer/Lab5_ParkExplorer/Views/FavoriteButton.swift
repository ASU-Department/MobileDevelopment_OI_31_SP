//
//  FavoriteButton.swift
//  Lab5_ParkExplorer
//
//  Created by Vitalik on 17.12.2025.
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var isFavorite: Bool
    let identifier: String

    var body: some View {
        Button {
            isFavorite.toggle()
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(isFavorite ? .red : .gray)
                .imageScale(.large)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier(identifier)
    }
}
