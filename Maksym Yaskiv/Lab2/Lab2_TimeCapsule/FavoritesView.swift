//
//  FavoritesView.swift
//  Lab2_TimeCapsule
//
//  Created by User on 26.10.2025.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Query(filter: #Predicate<HistoricalEvent> { $0.isFavorite == true }, sort: \HistoricalEvent.year)
    var favoriteEvents: [HistoricalEvent]

    var body: some View {
        NavigationStack {
            List {
                if favoriteEvents.isEmpty {
                    ContentUnavailableView("No favorites yet", systemImage: "star.slash")
                        .listRowSeparator(.hidden)
                } else {
                    ForEach(favoriteEvents) { event in
                        NavigationLink(destination: EventDetailView(event: event)) {
                            HStack {
                                Text(event.year)
                                    .bold()
                                    .foregroundStyle(.blue)
                                    .frame(width: 50, alignment: .leading)
                                
                                Text(event.text)
                                    .lineLimit(1)
                                    .foregroundStyle(.primary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .onDelete(perform: deleteFavorites)
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
            .padding(.top, 10)
            .listStyle(.plain) 
        }
    }