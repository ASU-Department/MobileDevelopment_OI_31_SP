//
//  NPSService.swift
//  ParkExplorer
//
//  Created by Vitalik on 18.12.2025.
//

import SwiftUI
import MapKit

final class NPSService {
    static let shared = NPSService()
    private let apiKey = "UQNEls1HOqeSdpiQeidAcSCON3mhvgKITD4Yuc3K"

    func fetchParks() async throws -> [ParkAPIModel] {
        let urlString =
        "https://developer.nps.gov/api/v1/parks?limit=20&api_key=\(apiKey)"

        let url = URL(string: urlString)!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(ParksResponse.self, from: data)
        return decoded.data
    }
}
