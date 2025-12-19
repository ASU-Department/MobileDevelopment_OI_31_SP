//
//  ParkAPIModel.swift
//  Lab5_ParkExplorer
//
//  Created by Vitalik on 18.12.2025.
//

struct ParksResponse: Codable {
    let data: [ParkAPIModel]
}

struct ParkAPIModel: Codable, Identifiable {
    let id: String
    let fullName: String
    let states: String
    let description: String
    let latitude: String?
    let longitude: String?
    let images: [ParkImage]
}

struct ParkImage: Codable {
    let url: String
}
