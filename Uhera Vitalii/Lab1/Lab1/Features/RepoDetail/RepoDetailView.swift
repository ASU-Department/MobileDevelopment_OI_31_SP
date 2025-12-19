//
//  RepositoryDetailView.swift
//  Lab1
//
//  Created by UnseenHand on 16.11.2025.
//

import SwiftUI

struct RepositoryDetailView: View {

    @ObservedObject var viewModel: RepoDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.repository.name)
                        .font(.title)
                        .bold()
                        .accessibilityIdentifier("repoTitle")

                    if let description = viewModel.repository.description {
                        Text(description)
                            .foregroundColor(.secondary)
                    }
                }

                Divider()

                Group {
                    InfoRow(
                        label: "Language",
                        value: viewModel.repository.language ?? "Unknown"
                    )
                    InfoRow(
                        label: "Stars",
                        value: "\(viewModel.repository.stargazersCount)"
                    )
                    InfoRow(
                        label: "Watchers",
                        value: "\(viewModel.repository.watchersCount)"
                    )
                    InfoRow(
                        label: "Open Issues",
                        value: "\(viewModel.repository.openIssuesCount)"
                    )
                    InfoRow(
                        label: "Forks",
                        value: "\(viewModel.repository.forksCount)"
                    )
                    InfoRow(
                        label: "Default Branch",
                        value: viewModel.repository.defaultBranch
                    )
                }

                Divider()

                if let link = viewModel.repository.htmlUrl {
                    Link("Open on GitHub", destination: link)
                        .font(.headline)
                        .foregroundColor(.blue)
                }

                Spacer()

                VStack(spacing: 12) {
                    Button {
                        viewModel.openDeveloperProfile()
                    } label: {
                        Label(
                            "Open Owner Profile",
                            systemImage: "person.circle"
                        )
                    }
                    .accessibilityIdentifier("openDeveloperButton")

                    Button {
                        viewModel.shareTapped()
                    } label: {
                        Label(
                            "Share Repository",
                            systemImage: "square.and.arrow.up"
                        )
                    }.sheet(isPresented: $viewModel.showShare) {
                        ShareSheetView(items: [
                            viewModel.repository.htmlUrl?.absoluteString
                                ?? viewModel.repository.fullName
                        ])
                    }
                    .accessibilityIdentifier("shareButton")
                }
            }
            .padding()
        }
        .navigationTitle("Repository")
        .navigationBarTitleDisplayMode(.inline)
    }
}
