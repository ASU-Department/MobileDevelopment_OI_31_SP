//
//  DevHubSearchView 2.swift
//  Lab1
//
//  Created by UnseenHand on 16.11.2025.
//

import SwiftUI

struct DevHubSearchView: View {
    @State private var query: String = ""
    @State private var showStarredOnly: Bool = false
    
    @State private var repositories: [Repository] = [
        Repository(name: "SwiftUI-Examples", description: "A collection of sample SwiftUI projects.", isStarred: false),
        Repository(name: "AI-Playground", description: "Machine learning experiments.", isStarred: true),
        Repository(name: "DevHub-App", description: "DevHub sample integration.", isStarred: false)
    ]
    
    var filteredRepos: [Binding<Repository>] {
        $repositories
            .filter { repoBinding in
                let repo = repoBinding.wrappedValue
                (query.isEmpty || repo.name.localizedCaseInsensitiveContains(query))
                && (!showStarredOnly || repo.isStarred)
            }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                
                // Search bar
                TextField("Search repositories...", text: $query)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // Toggle filter
                Toggle("Show starred only", isOn: $showStarredOnly)
                    .padding(.horizontal)
                
                // Repo List
                List {
                    ForEach(filteredRepos) { $repo in
                        RepoRow(repo: $repo)
                    }
                }
                
            }
            .navigationTitle("DevHub Search")
        }
    }
}
