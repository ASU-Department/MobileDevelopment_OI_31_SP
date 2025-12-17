//
//  GitHubAPIService.swift
//  Lab1
//
//  Created by UnseenHand on 15.12.2025.
//

import Foundation


final class GitHubAPIService: GitHubAPIServiceProtocol {

    private let session: URLSession
    private let baseURL = "https://api.github.com"

    init(session: URLSession = .shared) {
        self.session = session
    }

    private func makeRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.setValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        request.timeoutInterval = 15.0

        if let token = ProcessInfo.processInfo.environment["GITHUB_TOKEN"] {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    func fetchUser(username: String) async throws -> GitHubUserDTO {
        let url = URL(string: "\(baseURL)/users/\(username)")!
        let request = makeRequest(url: url)

        let (data, response) = try await session.data(for: request)
        try validate(response)
        return try JSONDecoder.github.decode(GitHubUserDTO.self, from: data)
    }

    func fetchRepositories(username: String) async throws -> [GitHubRepositoryDTO] {
        let url = URL(string: "\(baseURL)/users/\(username)/repos")!
        let request = makeRequest(url: url)

        let (data, response) = try await session.data(for: request)
        try validate(response)
        return try JSONDecoder.github.decode([GitHubRepositoryDTO].self, from: data)
    }

    private func validate(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse,
              200..<300 ~= http.statusCode else {
            throw NetworkError.invalidResponse
        }
    }
}
