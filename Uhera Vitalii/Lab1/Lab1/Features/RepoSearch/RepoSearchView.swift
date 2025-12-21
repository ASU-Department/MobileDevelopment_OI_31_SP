//
//  RepoListView.swift
//  Lab1
//
//  Created by UnseenHand on 16.11.2025.
//

import SwiftUI

struct RepoSearchView: View {
    @StateObject var viewModel: RepoSearchViewModel

    var body: some View {
        VStack(spacing: 12) {
            if viewModel.isOffline {
                HStack {
                    Image(systemName: "wifi.slash")
                    Text("Offline mode — showing cached data")
                        .font(.caption)
                        .bold()
                }
                .foregroundColor(.white)
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(Color.orange)
                .transition(.move(edge: .top))
            }

            HStack {
                TextField("GitHub username", text: $viewModel.username)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .accessibilityIdentifier("usernameField")

                Button("Load") {
                    Task {
                        await viewModel.load()
                    }
                }.accessibilityIdentifier("loadButton")
            }
            .padding(.horizontal)

            HStack {
                UISearchBarRepresentable(
                    text: $viewModel.searchText,
                    placeholder: "Search repos / language"
                )
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)

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
                            range: 0...10000,
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

            if viewModel.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                    Spacer()
                }
                .padding(.vertical, 8)
            }

            List(viewModel.filteredRepositories) { repo in
                RepositoryRow(
                    repository: repo,
                    isStarred: viewModel.isStarred(repo),
                    onToggleStar: { viewModel.toggleStar(repo) },
                    onOpenDetails: {
                        viewModel.openDetails(repo)
                    }
                )
                .listRowBackground(GitHubTheme.elevated)
                .accessibilityIdentifier("repoRow_\(repo.id)")
            }
            .listStyle(.plain)
            .refreshable {
                await viewModel.load()
            }

            if viewModel.isOffline && viewModel.repositories.isEmpty {
                Text("No cached repositories for this user.")
                    .foregroundColor(.secondary)
                    .padding()
            }
        }
        .navigationTitle("DevHub")
        .toolbarBackground(GitHubTheme.background, for: .navigationBar)
        .task {
            await viewModel.load()
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
