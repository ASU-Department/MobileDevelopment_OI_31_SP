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
        VStack(alignment: .leading, spacing: 16) {
            if let dev = viewModel.developer {
                HStack {
                    AsyncImage(url: dev.avatarUrl) { img in
                        img.resizable().scaledToFill()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 56, height: 56).clipShape(Circle())
                    VStack(alignment: .leading) {
                        Text(dev.name ?? dev.username).font(.headline)
                        Text(dev.bio ?? "").font(.subheadline)
                            .foregroundColor(GitHubTheme.secondaryText)
                    }
                    Spacer()
                    Button(action: {
                        viewModel.openDeveloperProfile()
                    }) {
                        Text("View Profile")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(GitHubTheme.background)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 12)
                }
            }

            Text(viewModel.repository.fullName)
                .font(.title)
                .bold()

            if let description = viewModel.repository.description {
                Text(description)
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

            Button {
                viewModel.shareTapped()
            } label: {
                Label("Share repo", systemImage: "square.and.arrow.up")
            }
            .sheet(isPresented: $viewModel.showShare) {
                ShareSheetView(items: [
                    viewModel.repository.htmlUrl?.absoluteString
                        ?? viewModel.repository.fullName
                ])
            }

        }
        .padding()
        .navigationTitle("Repository")
    }
}
