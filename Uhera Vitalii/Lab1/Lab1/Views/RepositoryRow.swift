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
            // Left tappable area -> opens details
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
            // make the tappable area clear and big
            .contentShape(Rectangle())
            .onTapGesture {
                onOpenDetails()
            }

            Spacer()

            // Star button — separate interactive area
            Button(action: onToggleStar) {
                Image(systemName: isStarred ? "star.fill" : "star")
                    .font(.system(size: 18))
                    .foregroundColor(isStarred ? .yellow : .gray)
                    .padding(8)
            }
            .buttonStyle(.borderless) // critical: keep button independent inside List
        }
        .padding(.vertical, 8)
    }
}

