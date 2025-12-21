//
//  GitHubRepositoryDTO.swift
//  Lab1
//
//  Created by UnseenHand on 15.12.2025.
//

import Foundation


struct GitHubRepositoryDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let language: String?
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int
    let topics: [String]
    let owner: OwnerDTO

    struct OwnerDTO: Codable {
        let login: String
        let avatarUrl: URL?
    }
}
