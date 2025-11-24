//
//  RepositoryDetailView.swift
//  Lab1
//
//  Created by UnseenHand on 16.11.2025.
//


import SwiftUI

struct RepositoryDetailView: View {
    let repository: Repository

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

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

                Link("Open on GitHub", destination: URL(string: repository.htmlURL)!)
                    .font(.headline)
                    .foregroundColor(.blue)

                Spacer()
            }
            .padding()
            .toolbarColorScheme(.dark, for: .navigationBar)
            .colorScheme(.dark)
        }
        .navigationTitle(repository.name)
        .background(Color.black)
    }
}

#Preview {
    RepositoryDetailView(repository: FakeRepositoryData.sample().first!)
}
