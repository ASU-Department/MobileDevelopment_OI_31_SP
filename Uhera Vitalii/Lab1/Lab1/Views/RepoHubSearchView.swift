//
//  RepoListView.swift
//  Lab1
//
//  Created by UnseenHand on 16.11.2025.
//


import SwiftUI

struct RepoHubSearchView: View {
    @StateObject private var viewModel = RepositoryViewModel()
    @State private var selectedRepository: Repository?
    @State private var selectedDeveloper: DeveloperProfile?
    @State private var loading: Bool = false
    @State private var showShareSheet = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                UISearchBarRepresentable(text: $viewModel.searchText, placeholder: "Search repos / language")
                    .padding(.horizontal)
                
                HStack {
                    Spacer()
                    ActivityIndicatorView(isAnimating: $loading, style: .medium)
                    Spacer()
                }

                Text("Min Watchers: \(viewModel.minWatchers)")
                    .foregroundColor(GitHubTheme.secondaryText)
                UIKitSliderView(value: Binding(get: { Int(viewModel.minWatchers) }, set: { viewModel.minWatchers = Int($0) }))
                    .frame(height: 36)
                    .padding(.horizontal)

                List(viewModel.filteredRepositories) { repo in
                    RepositoryRow(
                        repository: repo,
                        isStarred: viewModel.isStarred(repo),
                        onToggleStar: { viewModel.toggleStar(repo) },
                        onOpenDetails: {
                            selectedRepository = repo
                        }
                    )
                    .listRowBackground(GitHubTheme.elevated)
                }
                .listStyle(.plain)
            }
            .navigationTitle("DevHub")
            .task {
                loading = true
                await viewModel.load()
                loading = false
            }
            .navigationDestination(item: $selectedRepository) { repo in
                let dev = viewModel.developer(for: repo.owner.login)
                
                RepositoryDetailView(
                    repository: repo,
                    developer: dev,
                    onOpenProfile: { profile in
                        selectedDeveloper = profile
                    }
                )
            }
            .navigationDestination(item: $selectedDeveloper) { profile in
                DeveloperProfileView(profile: profile)
            }
        }
        .background(GitHubTheme.background.ignoresSafeArea())
        .foregroundStyle(GitHubTheme.text)
    }
}


extension Binding where Value == Int {
    var doubleValue: Binding<Double> {
        Binding<Double>(
            get: { Double(self.wrappedValue) },
            set: { self.wrappedValue = Int($0) }
        )
    }
}
