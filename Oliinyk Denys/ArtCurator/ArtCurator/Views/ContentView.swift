//
//  ContentView.swift
//  ArtCurator
//
//  Created by Denys Oliinyk on 05.11.2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject private var viewModel: ArtworkListViewModel
    @State private var showErrorAlert = false
    
    private let coordinator: AppCoordinator
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        _viewModel = StateObject(wrappedValue: ArtworkListViewModel(repository: coordinator.repository))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBar(
                    searchQuery: $viewModel.searchQuery,
                    filterFavorites: $viewModel.filterFavorites,
                    isLoading: viewModel.isLoading,
                    onSearch: { Task { await viewModel.fetchArtworks() } }
                )
                .onChange(of: viewModel.filterFavorites) { _, newValue in
                    UserDefaults.standard.set(newValue, forKey: "filterFavorites")
                }
                
                if let errorMessage = viewModel.errorMessage {
                    HStack {
                        Image(systemName: viewModel.isOffline ? "wifi.slash" : "exclamationmark.triangle")
                            .foregroundColor(viewModel.isOffline ? .orange : .red)
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
                
                if viewModel.isLoading {
                    VStack(spacing: 16) {
                        Spacer()
                        CustomIndicator(isAnimating: .constant(true), style: .large)
                        Text("Searching for \(viewModel.searchQuery.isEmpty ? "artworks" : "'\(viewModel.searchQuery)'")...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Spacer()
                    }
                } else if viewModel.filteredArtworks.isEmpty {
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
                            ForEach(viewModel.filteredArtworks) { artwork in
                                if let index = viewModel.artworks.firstIndex(where: { $0.id == artwork.id }) {
                                    NavigationLink(destination: ArtworkDetails(
                                        viewModel: coordinator.makeArtworkDetailViewModel(artwork: viewModel.artworks[index]))
                                    ) {
                                        ArtworkItem(artwork: $viewModel.artworks[index])
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .onAppear {
                                        if artwork.id == viewModel.filteredArtworks.last?.id && viewModel.hasMorePages {
                                            Task { await viewModel.loadMoreArtworks() }
                                        }
                                    }
                                }
                            }
                            
                            if viewModel.isLoadingMore {
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
                        await viewModel.fetchArtworks()
                    }
                }
            }
            .navigationTitle("Art Gallery")
            .task {
                if viewModel.artworks.isEmpty {
                    await viewModel.fetchArtworks()
                }
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "Unknown error")
            }
        }
    }
}
