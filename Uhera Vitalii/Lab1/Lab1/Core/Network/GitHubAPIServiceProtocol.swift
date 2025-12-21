//
//  GitHubAPIServiceProtocol.swift
//  Lab1
//
//  Created by UnseenHand on 15.12.2025.
//


import Foundation

protocol GitHubAPIServiceProtocol {
    func fetchUser(username: String) async throws -> GitHubUserDTO
    func fetchRepositories(username: String) async throws -> [GitHubRepositoryDTO]
}
