//
//  ContentView.swift
//  ArtCurator
//
//  Created by Denys Oliinyk on 05.11.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var artworkService = ArtworkService.shared
    @Environment(\.modelContext) private var modelContext
    @Query private var savedArtworks: [Artwork]

    @State private var searchQuery = ""
    @State private var filterFavorites = false
    @State private var showErrorAlert = false
    
    init() {
        _filterFavorites = State(initialValue: UserDefaults.standard.bool(forKey: "filterFavorites"))
        _searchQuery = State(initialValue: UserDefaults.standard.string(forKey: "searchQuery") ?? "")
    }
    
    private var filteredArtworks: [Artwork] {
        artworkService.artworks.filter { !filterFavorites || $0.isFavorite }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBar(
                    searchQuery: $searchQuery,
                    filterFavorites: $filterFavorites,
                    isLoading: artworkService.isLoading,
                    onSearch: performAPISearch
                )
                .onChange(of: filterFavorites) { _, newValue in
                    UserDefaults.standard.set(newValue, forKey: "filterFavorites")
                }
                
                if let errorMessage = artworkService.errorMessage {
                    HStack {
                        Image(systemName: artworkService.isOffline ? "wifi.slash" : "exclamationmark.triangle")
                            .foregroundColor(artworkService.isOffline ? .orange : .red)
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.yellow.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                
                if artworkService.isLoading {
                    VStack(spacing: 16) {
                        Spacer()
                        CustomIndicator(isAnimating: .constant(true), style: .large)
                        Text("Searching for \(searchQuery.isEmpty ? "artworks" : "'\(searchQuery)'")...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Spacer()
                    }
                } else if filteredArtworks.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "photo.artframe")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No artworks found")
                            .font(.headline)
                        Text("Try searching for an artist or title")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredArtworks) { artwork in
                                if let index = artworkService.artworks.firstIndex(where: {
                                    $0.id == artwork.id
                                }) {
                                    NavigationLink(destination: ArtworkDetails(
                                        artwork: $artworkService.artworks[index])
                                    ) {
                                        ArtworkItem(artwork: $artworkService.artworks[index])
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .onAppear {
                                        if artwork.id == filteredArtworks.last?.id && artworkService.hasMorePages {
                                            Task {
                                                await artworkService.loadMoreArtworks(modelContext: modelContext)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            if artworkService.isLoadingMore {
                                HStack(spacing: 8) {
                                    CustomIndicator(isAnimating: .constant(true), style: .medium)
                                    Text("Loading more...")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 16)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                    .refreshable {
                        await artworkService.fetchArtworks(modelContext: modelContext, query: searchQuery)
                    }
                }
            }
            .navigationTitle("Art Gallery")
            .task {
                if artworkService.artworks.isEmpty {
                    await artworkService.fetchArtworks(modelContext: modelContext, query: searchQuery)
                }
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(artworkService.errorMessage ?? "Unknown error")
            }
        }
    }
    
    private func performAPISearch() {
        Task {
            await artworkService.fetchArtworks(modelContext: modelContext, query: searchQuery)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Artwork.self, inMemory: true)
}
