//
//  WorkoutRepository.swift
//  lab1
//
//  Created by A-Z pack group on 09.12.2025.
//

import Foundation

protocol WorkoutRepository {
    func loadWorkouts() async throws -> [Workout]
    func saveWorkouts(_ workouts: [Workout]) async throws
    
    func fetchRemoteExercises() async throws -> [ExerciseAPIModel]
    func loadCachedRemoteExercises() async throws -> [ExerciseAPIModel]
    func saveCachedRemoteExercises(_ exercises: [ExerciseAPIModel]) async throws
}
