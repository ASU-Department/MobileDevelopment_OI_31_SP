//
//  GitHubRequestBuilder.swift
//  Lab1
//
//  Created by UnseenHand on 17.12.2025.
//


import Foundation

struct GitHubRequestBuilder {

    static func makeRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 15.0
        
        if let token = ProcessInfo.processInfo.environment["GITHUB_TOKEN"] {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }
}
