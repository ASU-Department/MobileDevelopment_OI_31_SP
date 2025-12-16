//
//  APODRepositoryProtocol.swift
//  SpaceExplorer2.0
//
//  Created by Pab1m on 13.12.2025.
//

import Foundation

protocol APODRepositoryProtocol {
    func loadAPOD() async throws -> APODResponse
}
