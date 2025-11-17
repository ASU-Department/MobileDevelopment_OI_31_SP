//
//  RepoListView.swift
//  Lab1
//
//  Created by UnseenHand on 16.11.2025.
//


import SwiftUI

struct RepoHubSearchView: View {
    @StateObject private var viewModel = RepositoryViewModel()
    @State private var selectedRepository: Repository?   // Needed for navigation
    @State var val = 0
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {

                // 🔍 Search
                TextField("Search repositories…", text: $viewModel.searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)

                // ⭐ Starred toggle
                Toggle("Show Starred Only", isOn: $viewModel.showStarredOnly)
                    .padding(.horizontal)

                // 🎚 Sliders
                VStack(spacing: 12) {
                    SliderRow(
                        title: "Min Watchers",
                        value: $viewModel.minWatchers,
                        range: 0...5000
                    )

                    SliderRow(
                        title: "Min Issues",
                        value: $viewModel.minIssues,
                        range: 0...2000
                    )
                }
                .padding(.horizontal)

                SliderRow(
                    title: "Min Issues",
                    value: $val,
                    range: 0...2000
                )
                
                // 📜 Repositories List
                List(viewModel.filteredRepositories) { repo in
                    RepositoryRow(
                        repository: repo,
                        isStarred: viewModel.isStarred(repo),
                        onToggleStar: {
                            viewModel.toggleStar(repo)
                        },
                        onOpenDetails: {
                            // set selected repo (navigationDestination will trigger)
                            selectedRepository = repo
                        }
                    )
                }
                .listStyle(.plain)
            }
            .navigationTitle("DevHub Search")
            .navigationDestination(item: $selectedRepository) { repo in
                RepositoryDetailView(repository: repo)
            }
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
