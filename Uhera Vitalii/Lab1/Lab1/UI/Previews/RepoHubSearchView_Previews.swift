//
//  DevHubSearchView.swift
//  Lab1
//
//  Created by UnseenHand on 16.11.2025.
//


import SwiftUI

struct RepoHubSearchView_Previews: PreviewProvider {
    static var previews: some View {
        RepoSearchView(viewModel: RepoSearchViewModel(repository: MockModels.sampleRepos().first as! GitHubRepositoryProtocol, coordinator: AppCoordinator(repository: MockModels.sampleRepos().first as! GitHubRepositoryProtocol)))
    }
}
