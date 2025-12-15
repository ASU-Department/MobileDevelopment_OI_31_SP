//
//  ExerciseSearchResponse.swift
//  lab1
//
//  Created by A-Z pack group on 09.12.2025.
//

import Foundation

import Foundation

struct ExerciseSearchResponse: Codable {
    let success: Bool?
    let data: [ExerciseAPIModel]
}
