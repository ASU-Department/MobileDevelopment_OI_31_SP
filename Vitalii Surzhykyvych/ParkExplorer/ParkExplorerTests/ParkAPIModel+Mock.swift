//
//  ParkAPIModel+Mock.swift
//  ParkExplorer
//
//  Created by Vitalik on 19.12.2025.
//

import Foundation
@testable import ParkExplorer

extension ParkAPIModel {
    static func mock(id: String) -> ParkAPIModel {
        ParkAPIModel(
            id: id,
            fullName: "Test Park",
            states: "CA",
            description: "Test",
            latitude: nil,
            longitude: nil,
            images: []
        )
    }
}
