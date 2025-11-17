//
//  FavoritesView.swift
//  Lab2_TimeCapsule
//
//  Created by User on 26.10.2025.
//

import SwiftUI

struct FavoritesView: View {
    @Binding var events: [HistoricalEvent]

    var favoriteEvents: [HistoricalEvent] {
        events.filter { $0.isFavorite }
    }

    var body: some View {
        NavigationStack {
            List {
                if favoriteEvents.isEmpty {
                    Text("No favorites yet")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(favoriteEvents) { event in
                        NavigationLink(destination: EventDetailView(event: event)) {
                            HStack {
                                Text(event.text)
                                Spacer()
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesView(events: .constant([
            HistoricalEvent(text: "My Favorite Event", urlString: "...", isFavorite: true),
            HistoricalEvent(text: "Not Favorite", urlString: "...", isFavorite: false)
        ]))
    }
}