//
//  NetworkService.swift
//  lab1
//
//  Created by witold on 14.12.2025.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    private let token = "04839fd87e593b3fa853a64eb67b964beadaf778"
    
    func fetchAQI(for city: String) async throws -> AQCoreData {
        let url = URL(string: "https://api.waqi.info/feed/\(city)/?token=\(token)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(AQResponse.self, from: data)
        
        guard decoded.status == "ok", let core = decoded.data else {
            throw URLError(.badServerResponse)
        }
        
        return core
    }
}
