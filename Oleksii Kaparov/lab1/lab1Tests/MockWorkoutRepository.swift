//
//  MockWorkoutRepository.swift
//  lab1Tests
//
//  Created by A-Z pack group on 16.12.2025.
//

import Foundation
@testable import lab1

final class MockWorkoutRepository: WorkoutRepository {
    // MARK: - Configurable behavior

    var loadWorkoutsResult: Result<[Workout], Error> = .success([])
    var saveWorkoutsResult: Result<Void, Error> = .success(())
    var deleteWorkoutResult: Result<Void, Error> = .success(())

    var fetchRemoteExercisesResult: Result<[ExerciseAPIModel], Error> = .success([])
    var loadCachedRemoteExercisesResult: Result<[ExerciseAPIModel], Error> = .success([])
    var saveCachedRemoteExercisesResult: Result<Void, Error> = .success(())

    // Optional artificial delay (to test loading flags)
    var artificialDelayNanos: UInt64 = 0

    // MARK: - Call tracking

    private(set) var savedWorkoutsSnapshots: [[Workout]] = []
    private(set) var deletedWorkoutIDs: [UUID] = []
    private(set) var fetchQueries: [String] = []
    private(set) var cachedRemoteSavedSnapshots: [[ExerciseAPIModel]] = []

    // MARK: - WorkoutRepository

    func loadWorkouts() async throws -> [Workout] {
        if artificialDelayNanos > 0 { try await Task.sleep(nanoseconds: artificialDelayNanos) }
        return try loadWorkoutsResult.get()
    }

    func saveWorkouts(_ workouts: [Workout]) async throws {
        if artificialDelayNanos > 0 { try await Task.sleep(nanoseconds: artificialDelayNanos) }
        savedWorkoutsSnapshots.append(workouts)
        try saveWorkoutsResult.get()
    }

    func deleteWorkout(id: UUID) async throws {
        if artificialDelayNanos > 0 { try await Task.sleep(nanoseconds: artificialDelayNanos) }
        deletedWorkoutIDs.append(id)
        try deleteWorkoutResult.get()
    }

    func fetchRemoteExercises(search: String) async throws -> [ExerciseAPIModel] {
        if artificialDelayNanos > 0 { try await Task.sleep(nanoseconds: artificialDelayNanos) }
        fetchQueries.append(search)
        return try fetchRemoteExercisesResult.get()
    }

    func loadCachedRemoteExercises() async throws -> [ExerciseAPIModel] {
        if artificialDelayNanos > 0 { try await Task.sleep(nanoseconds: artificialDelayNanos) }
        return try loadCachedRemoteExercisesResult.get()
    }

    func saveCachedRemoteExercises(_ exercises: [ExerciseAPIModel]) async throws {
        if artificialDelayNanos > 0 { try await Task.sleep(nanoseconds: artificialDelayNanos) }
        cachedRemoteSavedSnapshots.append(exercises)
        try saveCachedRemoteExercisesResult.get()
    }
}
