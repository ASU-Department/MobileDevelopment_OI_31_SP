//
//  ExerciseModel.swift
//  lab1
//
//  Created by A-Z pack group on 25.10.2025.
//

import Foundation

struct ExerciseItem: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var sets: Int
    var reps: Int
}
