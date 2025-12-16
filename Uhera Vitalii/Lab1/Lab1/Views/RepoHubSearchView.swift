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
                HStack {
                    UISearchBarRepresentable(
                        text: $viewModel.searchText,
                        placeholder: "Search repos / language"
                    )
                    .padding(.horizontal)
                }
                
                HStack {
                    Spacer()
                    ActivityIndicatorView(isAnimating: $loading, style: .medium)
                    Spacer()
                }

                VStack(spacing: 0) {
                    Button {
                        withAnimation(.spring) {
                            viewModel.showAdvancedFilters.toggle()
                        }
                    } label: {
                        HStack {
                            Text("Advanced Filters")
                                .font(.headline)
                            Spacer()
                            Image(
                                systemName: viewModel.showAdvancedFilters
                                    ? "chevron.up" : "chevron.down"
                            )
                        }
                        .padding()
                        .background(GitHubTheme.background)
                    }

                    if viewModel.showAdvancedFilters {
                        VStack(spacing: 18) {
                            Toggle(
                                "Use Slider Mode",
                                isOn: $viewModel.useSliderMode
                            )
                            .padding(.horizontal)

                            FilterValueInputRow(
                                title: "Minimum Stars",
                                sliderValue: $viewModel.minStars,
                                range: 0...300000,
                                usesSlider: viewModel.useSliderMode
                            )

                            FilterValueInputRow(
                                title: "Minimum Issues",
                                sliderValue: $viewModel.minIssues,
                                range: 0...2000,
                                usesSlider: viewModel.useSliderMode
                            )
                            FilterValueInputRow(
                                title: "Minimum Watchers",
                                sliderValue: $viewModel.minWatchers,
                                range: 0...10000,
                                usesSlider: viewModel.useSliderMode
                            )

                            Toggle(
                                "Show Starred Only",
                                isOn: $viewModel.showOnlyStarred
                            )
                            .padding(.horizontal)

                            Toggle(
                                "Only Repos with Open Issues",
                                isOn: $viewModel.showOnlyWithIssues
                            )
                            .padding(.horizontal)

                            Picker("Sort By", selection: $viewModel.sortMode) {
                                ForEach(RepoSortMode.allCases) { mode in
                                    Text(mode.rawValue).tag(mode)
                                }
                            }
                            .pickerStyle(.segmented)
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                        .background(GitHubTheme.background)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }

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
            .toolbarBackground(GitHubTheme.background, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
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
            .background(GitHubTheme.background.ignoresSafeArea())
            .foregroundStyle(GitHubTheme.text)
        }
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
