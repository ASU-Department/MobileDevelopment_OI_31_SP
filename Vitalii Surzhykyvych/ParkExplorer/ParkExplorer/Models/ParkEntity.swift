//
//  ParkEntity.swift
//  Lab3_ParkExplorer
//
//  Created by Vitalik on 18.12.2025.
//

import SwiftData

@Model
class ParkEntity {
    var id: String
    var name: String
    var state: String
    var descriptionText: String

    init(from api: ParkAPIModel) {
        self.id = api.id
        self.name = api.fullName
        self.state = api.states
        self.descriptionText = api.description
    }
}
