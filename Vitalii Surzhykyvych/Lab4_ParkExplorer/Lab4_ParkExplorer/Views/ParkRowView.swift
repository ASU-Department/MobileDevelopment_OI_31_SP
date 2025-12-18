//
//  ParkRowView.swift
//  Lab4_ParkExplorer
//
//  Created by Vitalik on 17.12.2025.
//

import SwiftUI

struct ParkRowView: View {
    @Binding var park: Park

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(park.name)
                    .font(.headline)
                Text(park.state)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            FavoriteButton(isFavorite: $park.isFavorite)
        }
        .padding(.vertical, 6)
    }
}
