//
//  Repository.swift
//  Lab1
//
//  Created by UnseenHand on 16.11.2025.
//


import Foundation

struct Repository: Identifiable, Hashable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let language: String?
    let stargazersCount: Int
    let watchersCount: Int
    let openIssuesCount: Int
    let forksCount: Int
    let htmlURL: String
    let defaultBranch: String
    let createdAt: Date
    let updatedAt: Date
    let owner: RepositoryOwner
}
