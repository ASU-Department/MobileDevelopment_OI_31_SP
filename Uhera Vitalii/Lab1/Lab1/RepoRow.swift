//
//  RepoRow.swift
//  Lab1
//
//  Created by UnseenHand on 16.11.2025.
//


// MARK: - Child View

struct RepoRow: View {
    @Binding var repo: Repository
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(repo.name)
                    .font(.headline)
                Text(repo.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Button {
                repo.isStarred.toggle()
            } label: {
                Image(systemName: repo.isStarred ? "star.fill" : "star")
                    .foregroundColor(repo.isStarred ? .yellow : .gray)
                    .imageScale(.large)
            }
            .buttonStyle(.borderless)
        }
        .padding(.vertical, 4)
    }
}