//
//  WorkoutViewModel.swift
//  lab1
//
//  Created by A-Z pack group on 02.11.2025.
//
import Foundation
import SwiftUI

@MainActor
final class WorkoutViewModel: ObservableObject {
    // Builder state
    @Published var workoutName: String = ""
    @Published var exercises: [ExerciseItem] = []
    @Published var intensity: Double = 0.5

    // Alerts
    @Published var showingAlert: Bool = false
    @Published var lastSaveMessage: String = ""

    // Saved workouts
    @Published var workouts: [Workout] = []

    // Remote exercises (ExerciseDB)
    @Published var remoteExercises: [ExerciseAPIModel] = []
    @Published var isLoadingRemote: Bool = false
    @Published var remoteErrorMessage: String? = nil
    @Published var isOfflineFallback: Bool = false
    @Published var lastSyncText: String? = nil

    private let repository: WorkoutRepository

    init(repository: WorkoutRepository) {
        self.repository = repository
    }

    // MARK: - Builder actions

    func addExercise() {
        let baseName = workoutName.isEmpty ? "Exercise" : workoutName
        exercises.append(ExerciseItem(name: baseName, sets: 3, reps: 10))
    }

    func addExerciseFromRemote(_ ex: ExerciseAPIModel) {
        exercises.append(ExerciseItem(name: ex.name, sets: 3, reps: 10))
    }

    func deleteExercise(at offsets: IndexSet) {
        exercises.remove(atOffsets: offsets)
    }

    // MARK: - Persistence (Core Data via Repository/Actor)

    func loadInitialData() {
        Task {
            do {
                let loaded = try await repository.loadWorkouts()
                workouts = loaded

                let cached = try await repository.loadCachedRemoteExercises()
                remoteExercises = cached

                if let ts = UserDefaults.standard.object(forKey: "lastExerciseSyncDate") as? TimeInterval {
                    lastSyncText = Self.format(date: Date(timeIntervalSince1970: ts))
                }
            } catch {
                // keep silent / optionally show message
                print("Load error:", error)
            }
        }
    }

    func saveWorkout() {
        guard !workoutName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            lastSaveMessage = "Please enter a workout name before saving."
            showingAlert = true
            return
        }
        guard !exercises.isEmpty else {
            lastSaveMessage = "Add at least one exercise before saving."
            showingAlert = true
            return
        }

        let newWorkout = Workout(
            id: UUID(),
            name: workoutName,
            exercises: exercises,
            date: Date(),
            intensity: intensity
        )

        workouts.append(newWorkout)

        Task {
            do {
                try await repository.saveWorkouts(workouts)
                lastSaveMessage = "Saved \"\(newWorkout.name)\" with \(newWorkout.exercises.count) exercise(s)."

                workoutName = ""
                exercises.removeAll()
                intensity = 0.5
                showingAlert = true
            } catch {
                lastSaveMessage = "Save failed: \(error.localizedDescription)"
                showingAlert = true
            }
        }
    }

    func deleteWorkout(at offsets: IndexSet) {
        let ids = offsets.map { workouts[$0].id }
        workouts.remove(atOffsets: offsets)

        Task {
            do {
                for id in ids {
                    try await repository.deleteWorkout(id: id)
                }
            } catch {
                print("Delete error:", error)
            }
        }
    }

    // MARK: - Networking

    func fetchExercises(query: String = "strength exercises") {
        isLoadingRemote = true
        remoteErrorMessage = nil
        isOfflineFallback = false

        Task {
            do {
                let decoded = try await repository.fetchRemoteExercises(search: query)
                remoteExercises = decoded
                isLoadingRemote = false
                remoteErrorMessage = nil
                isOfflineFallback = false
try await repository.saveCachedRemoteExercises(decoded)

                let now = Date()
                UserDefaults.standard.set(now.timeIntervalSince1970, forKey: "lastExerciseSyncDate")
                lastSyncText = Self.format(date: now)

            } catch {
                // Offline fallback
                isLoadingRemote = false
                remoteErrorMessage = "Could not load exercises from network. Showing cached data if available."
                isOfflineFallback = true

                do {
                    let cached = try await repository.loadCachedRemoteExercises()
                    remoteExercises = cached
                } catch {
                    // no cache
                    print("Cache load error:", error)
                }
            }
        }
    }

    static func format(date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        return f.string(from: date)
    }
}
