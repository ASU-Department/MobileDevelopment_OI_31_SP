//
//  CachedRepository.swift
//  Lab1
//
//  Created by UnseenHand on 15.12.2025.
//

import Foundation
import SwiftData

@Model
final class CachedRepository {
    @Attribute(.unique) var id: Int
    var name: String
    var fullName: String
    var stars: Int
    var watchers: Int
    var issues: Int
    var language: String?
    var ownerLogin: String
    
    init(
        id: Int,
        name: String,
        fullName: String,
        stars: Int,
        watchers: Int,
        issues: Int,
        language: String? = nil,
        ownerLogin: String
    ) {
        self.id = id
        self.name = name
        self.fullName = fullName
        self.stars = stars
        self.watchers = watchers
        self.issues = issues
        self.language = language
        self.ownerLogin = ownerLogin
    }
}

@Model
final class CachedUser {
    @Attribute(.unique) var id: Int
    var username: String
    var avatarUrl: URL
    var followers: Int
    var following: Int

    init(
        id: Int,
        username: String,
        avatarUrl: URL,
        followers: Int,
        following: Int
    ) {
        self.id = id
        self.username = username
        self.avatarUrl = avatarUrl
        self.followers = followers
        self.following = following
    }
}
