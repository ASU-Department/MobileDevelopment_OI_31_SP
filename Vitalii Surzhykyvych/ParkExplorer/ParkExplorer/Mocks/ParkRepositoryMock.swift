//
//  ParkRepositoryMock.swift
//  Lab5_ParkExplorer
//
//  Created by Vitalik on 20.12.2025.
//

import Foundation

final class ParkRepositoryMock: ParkRepositoryProtocol {

    var parksToReturn: [ParkAPIModel] = []
    var shouldThrowError = false

    func fetchParks() async throws -> [ParkAPIModel] {
        if shouldThrowError {
            throw URLError(.notConnectedToInternet)
        }
        return parksToReturn
    }

    func loadCachedParks() throws -> [ParkAPIModel] {
        parksToReturn
    }

    func saveParks(_ parks: [ParkAPIModel]) async {}
}
