//
//  DefaultWorkoutRepository.swift
//  lab1
//
//  Created by A-Z pack group on 09.12.2025.
//

import Foundation

final class DefaultWorkoutRepository: WorkoutRepository {
    private let storage: WorkoutCoreDataActor
    private let api: ExerciseAPIService

    init(storage: WorkoutCoreDataActor, api: ExerciseAPIService) {
        self.storage = storage
        self.api = api
    }

    func loadWorkouts() async throws -> [Workout] {
        try await storage.loadWorkouts()
    }

    func saveWorkouts(_ workouts: [Workout]) async throws {
        try await storage.saveWorkouts(workouts)
    }

    func deleteWorkout(id: UUID) async throws {
        try await storage.deleteWorkout(id: id)
    }

    func fetchRemoteExercises(search: String) async throws -> [ExerciseAPIModel] {
        try await api.searchExercises(search: search)
    }

    func loadCachedRemoteExercises() async throws -> [ExerciseAPIModel] {
        try await storage.loadCachedRemoteExercises()
    }

    func saveCachedRemoteExercises(_ exercises: [ExerciseAPIModel]) async throws {
        try await storage.saveCachedRemoteExercises(exercises)
    }
}
