//
//  ExerciseAPIModel.swift
//  lab1
//
//  Created by A-Z pack group on 16.11.2025.
//

import Foundation

struct ExerciseAPIModel: Identifiable, Codable, Hashable{
    let id: String
    let name: String
    let bodyPart: String
    let target: String
    let equipment: String
    let difficulty: String?
    let category: String?
}
