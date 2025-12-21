//
//  RepoRow.swift
//  Lab1
//
//  Created by UnseenHand on 16.11.2025.
//


import SwiftUI

struct RepositoryRow: View {
    let repository: Repository
    let isStarred: Bool
    let onToggleStar: () -> Void
    let onOpenDetails: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(repository.name)
                    .font(.headline)
                    .lineLimit(1)

                if let desc = repository.description {
                    Text(desc)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }

                HStack(spacing: 12) {
                    Label("\(repository.stargazersCount)", systemImage: "star.fill")
                    Label("\(repository.watchersCount)", systemImage: "eye.fill")
                    Label("\(repository.openIssuesCount)", systemImage: "exclamationmark.triangle")
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onOpenDetails()
            }
            .accessibilityIdentifier("repoRowButton_\(repository.id)")

            Spacer()
            
            Button(action: onToggleStar) {
                Image(systemName: isStarred ? "star.fill" : "star")
                    .font(.system(size: 18))
                    .foregroundColor(isStarred ? .yellow : .gray)
                    .padding(8)
            }
            .buttonStyle(.borderless)
            .accessibilityIdentifier("starButton_\(repository.id)")
        }
        .padding(.vertical, 8)
    }
}

