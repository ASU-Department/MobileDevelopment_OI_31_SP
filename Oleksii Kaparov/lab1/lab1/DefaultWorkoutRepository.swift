//
//  DefaultWorkoutRepository.swift
//  lab1
//
//  Created by A-Z pack group on 09.12.2025.
//

import Foundation

final class DefaultWorkoutRepository: WorkoutRepository {
    private let storage: WorkoutStorageActor
    
    init(storage: WorkoutStorageActor = WorkoutStorageActor()) {
        self.storage = storage
    }
    
    // MARK: - Local
    
    func loadWorkouts() async throws -> [Workout] {
        try await storage.loadWorkouts()
    }
    
    func saveWorkouts(_ workouts: [Workout]) async throws {
        try await storage.saveWorkouts(workouts)
    }
    
    func loadCachedRemoteExercises() async throws -> [ExerciseAPIModel] {
        try await storage.loadCachedRemoteExercises()
    }
    
    func saveCachedRemoteExercises(_ exercises: [ExerciseAPIModel]) async throws {
        try await storage.saveCachedRemoteExercises(exercises)
    }
    
    // MARK: - Remote (ExerciseDB)
    
    func fetchRemoteExercises() async throws -> [ExerciseAPIModel] {
        guard let url = URL(string: "https://exercisedb-api1.p.rapidapi.com/api/v1/exercises/search?search=strength%20exercises") else {
            return []
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("53d448ddcamsh091e87c2b35cbf0p136a29jsn451249ed86da", forHTTPHeaderField: "X-RapidAPI-Key")
        request.setValue("exercisedb-api1.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let http = response as? HTTPURLResponse,
           !(200...299).contains(http.statusCode) {
            let body = String(data: data, encoding: .utf8) ?? "<no body>"
            print("❌ HTTP error:", http.statusCode, body)
            throw NSError(domain: "ExerciseDB", code: http.statusCode, userInfo: nil)
        }
        
        let wrapper = try JSONDecoder().decode(ExerciseSearchResponse.self, from: data)
        return wrapper.data
    }
}
