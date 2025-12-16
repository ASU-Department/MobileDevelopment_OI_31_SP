//
//  FavoritesView.swift
//  Lab2_TimeCapsule
//
//  Created by User on 26.10.2025.
//


import SwiftUI
import SwiftData

struct FavoritesView: View {
    @StateObject private var viewModel: FavoritesViewModel
    
    let repository: any TimeCapsuleRepositoryProtocol
    
    init(repository: any TimeCapsuleRepositoryProtocol) {
        self.repository = repository
        _viewModel = StateObject(wrappedValue: FavoritesViewModel(repository: repository))
    }

    var body: some View {
        NavigationStack {
            List {
                if viewModel.favoriteEvents.isEmpty {
                    ContentUnavailableView("No favorites yet", systemImage: "star.slash")
                        .listRowSeparator(.hidden)
                } else {
                    ForEach(viewModel.favoriteEvents) { event in
                        NavigationLink(destination: EventDetailView(event: event, repository: repository))
                        {
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
                    .onDelete(perform: viewModel.deleteFavorites)
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
            .padding(.top, 10)
            .listStyle(.plain)
            .onAppear {
                Task {
                    await viewModel.loadFavorites()
                }
            }
        }
    }
}