//
//  WorkoutStorageActor.swift
//  lab1
//
//  Created by A-Z pack group on 09.12.2025.
//

import Foundation

actor WorkoutStorageActor {
    private let workoutsURL: URL
    private let remoteExercisesURL: URL
    
    init() {
        let dir = FileManager.default.urls(for: .documentDirectory,
                                           in: .userDomainMask).first!
        workoutsURL = dir.appendingPathComponent("workouts.json")
        remoteExercisesURL = dir.appendingPathComponent("remote_exercises.json")
    }
    
    // MARK: - Workouts
    
    func loadWorkouts() throws -> [Workout] {
        guard FileManager.default.fileExists(atPath: workoutsURL.path) else {
            return []
        }
        let data = try Data(contentsOf: workoutsURL)
        return try JSONDecoder().decode([Workout].self, from: data)
    }
    
    func saveWorkouts(_ workouts: [Workout]) throws {
        let data = try JSONEncoder().encode(workouts)
        try data.write(to: workoutsURL, options: .atomic)
    }
    
    // MARK: - Cached remote exercises
    
    func loadCachedRemoteExercises() throws -> [ExerciseAPIModel] {
        guard FileManager.default.fileExists(atPath: remoteExercisesURL.path) else {
            return []
        }
        let data = try Data(contentsOf: remoteExercisesURL)
        return try JSONDecoder().decode([ExerciseAPIModel].self, from: data)
    }
    
    func saveCachedRemoteExercises(_ exercises: [ExerciseAPIModel]) throws {
        let data = try JSONEncoder().encode(exercises)
        try data.write(to: remoteExercisesURL, options: .atomic)
    }
}
