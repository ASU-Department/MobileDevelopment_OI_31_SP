//
//  Workout.swift
//  lab1
//
//  Created by A-Z pack group on 25.10.2025.
//

import Foundation

struct Workout: Identifiable, Hashable{
    let id = UUID()
    var name: String
    var exercises: [ExerciseItem]
    var date: Date = Date()
}
