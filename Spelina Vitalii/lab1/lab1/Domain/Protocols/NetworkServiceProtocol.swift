//
//  NetworkServiceProtocol.swift
//  lab1
//
//  Created by witold on 14.12.2025.
//

protocol NetworkServiceProtocol {
    func fetchAQI(for city: String) async throws -> AQCoreData
}
