//
//  DeveloperProfile.swift
//  Lab1
//
//  Created by UnseenHand on 07.12.2025.
//

import Foundation

struct DeveloperProfile: Identifiable, Hashable {
    let id: UUID = UUID()
    let username: String
    let name: String?
    let bio: String?
    let avatarUrl: URL?
    let followers: Int
    let following: Int
    let publicRepos: Int
    
    var repos: [Repository] = []
}
