//
//  GitHubUserDTO.swift
//  Lab1
//
//  Created by UnseenHand on 15.12.2025.
//

import Foundation


struct GitHubUserDTO: Codable, Identifiable {
    let id: Int
    let login: String
    let avatarUrl: URL
    let name: String?
    let bio: String?
    let followers: Int
    let following: Int
    let publicRepos: Int
}
