//
//  RepositoryDetailView.swift
//  Lab1
//
//  Created by UnseenHand on 16.11.2025.
//


import SwiftUI

struct RepositoryDetailView: View {
    let repository: Repository
    let developer: DeveloperProfile?  // optional additional info
    let onOpenProfile: (DeveloperProfile) -> Void

    @State private var showShare = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // headers
                
                if let dev = developer {
                    HStack {
                        AsyncImage(url: dev.avatarUrl) { img in img.resizable().scaledToFill() } placeholder: { Color.gray }
                            .frame(width: 56, height: 56).clipShape(Circle())
                        VStack(alignment: .leading) {
                            Text(dev.name ?? dev.username).font(.headline)
                            Text(dev.bio ?? "").font(.subheadline).foregroundColor(GitHubTheme.secondaryText)
                        }
                        Spacer()
                        Button(action: {
                            onOpenProfile(dev)
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
                
                Text(repository.fullName)
                    .font(.title)
                    .bold()

                if let desc = repository.description {
                    Text(desc)
                        .font(.body)
                }

                Divider()

                Group {
                    InfoRow(label: "Language", value: repository.language ?? "Unknown")
                    InfoRow(label: "Stars", value: "\(repository.stargazersCount)")
                    InfoRow(label: "Watchers", value: "\(repository.watchersCount)")
                    InfoRow(label: "Open Issues", value: "\(repository.openIssuesCount)")
                    InfoRow(label: "Forks", value: "\(repository.forksCount)")
                    InfoRow(label: "Default Branch", value: repository.defaultBranch)
                }

                Divider()

                if let link = repository.htmlUrl {
                    Link("Open on GitHub", destination: link)
                        .font(.headline)
                        .foregroundColor(.blue)
                }

                Spacer()
                
                Button(action: { showShare = true }) {
                    Label("Share repo", systemImage: "square.and.arrow.up")
                }
                .sheet(isPresented: $showShare) {
                    ShareSheetView(items: [repository.htmlUrl?.absoluteString ?? repository.fullName])
                }
            }
            .padding()
        }
        .navigationTitle(repository.name)
        .background(GitHubTheme.background)
    }
}

//#Preview {
//    RepositoryDetailView(repository: FakeRepositoryData.sample().first!)
//}
