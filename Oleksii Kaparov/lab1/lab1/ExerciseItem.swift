//
//  ExerciseItem.swift
//  lab1
//
//  Created by A-Z pack group on 18.11.2025.
//

import Foundation

struct ExerciseItem: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var sets: Int
    var reps: Int
    
    init(id: UUID = UUID(), name: String, sets: Int, reps: Int) {
        self.id = id
        self.name = name
        self.sets = sets
        self.reps = reps
    }
}
