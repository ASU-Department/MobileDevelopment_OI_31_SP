//
//  Workout.swift
//  lab1
//
//  Created by A-Z pack group on 02.11.2025.
//
import Foundation

struct Workout: Identifiable, Hashable, Codable{
    let id: UUID
    var name: String
    var exercises: [ExerciseItem]
    var date: Date = Date()
    var intensity: Double = 0.5
}
