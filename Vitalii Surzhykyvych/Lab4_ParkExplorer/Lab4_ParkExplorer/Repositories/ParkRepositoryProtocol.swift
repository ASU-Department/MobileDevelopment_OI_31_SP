//
//  ParkRepositoryProtocol.swift
//  Lab4_ParkExplorer
//
//  Created by Vitalik on 19.12.2025.
//

protocol ParkRepositoryProtocol {
    func fetchParks() async throws -> [ParkAPIModel]
    func loadCachedParks() async throws -> [ParkAPIModel]
    func saveParks(_ parks: [ParkAPIModel]) async
}
