//
//  WorkoutViewModel.swift
//  lab1
//
//  Created by A-Z pack group on 02.11.2025.
//
import Foundation
import Combine
import SwiftUI

@MainActor
final class WorkoutViewModel: ObservableObject {
    // MARK: - UI State
    @Published var workoutName: String = ""
    @Published var exercises: [ExerciseItem] = []
    @Published var intensity: Double = 0.5

    @Published var showingAlert: Bool = false
    @Published var lastSaveMessage: String = ""
    @Published var workouts: [Workout] = []

    // ExerciseDB remote data
    @Published var remoteExercises: [ExerciseAPIModel] = []
    @Published var isLoadingRemote: Bool = false
    @Published var remoteErrorMessage: String?
    @Published var isOfflineFallback: Bool = false

    // Last sync text for UI
    @Published var lastSyncText: String?

    // MARK: - File URLs

    private var workoutsURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("workouts.json")
    }

    private var remoteExercisesURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("remote_exercises.json")
    }

    // MARK: - Init

    init() {
        loadPersistedWorkouts()
        loadLastSyncFromDefaults()
        fetchExercises()
    }

    // MARK: - Local workout actions

    func addExercise() {
        let baseName = workoutName.isEmpty ? "Exercise" : workoutName
        exercises.append(ExerciseItem(name: baseName, sets: 3, reps: 10))
    }

    func addExerciseFromRemote(_ remote: ExerciseAPIModel) {
        let baseName = remote.name
        exercises.append(ExerciseItem(name: baseName, sets: 3, reps: 10))
    }

    func deleteExercise(at offsets: IndexSet) {
        exercises.remove(atOffsets: offsets)
    }

    func saveWorkout() {
        guard !workoutName.isEmpty else {
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
        persistWorkouts()

        lastSaveMessage = "Saved \"\(workoutName)\" with \(exercises.count) exercise(s)."
        workoutName = ""
        exercises.removeAll()
        intensity = 0.5
        showingAlert = true
    }

    func deleteWorkout(at offsets: IndexSet) {
        workouts.remove(atOffsets: offsets)
        persistWorkouts()
    }

    // MARK: - JSON persistence

    private func persistWorkouts() {
        do {
            let data = try JSONEncoder().encode(workouts)
            try data.write(to: workoutsURL, options: .atomic)
        } catch {
            print("Failed to save workouts: \(error)")
        }
    }

    private func loadPersistedWorkouts() {
        guard FileManager.default.fileExists(atPath: workoutsURL.path) else { return }
        do {
            let data = try Data(contentsOf: workoutsURL)
            let decoded = try JSONDecoder().decode([Workout].self, from: data)
            self.workouts = decoded
        } catch {
            print("Failed to load workouts: \(error)")
        }
    }

    private func saveRemoteExercisesToDisk(_ items: [ExerciseAPIModel]) {
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: remoteExercisesURL, options: .atomic)
        } catch {
            print("Failed to save remote exercises: \(error)")
        }
    }
    
private func loadCachedRemoteExercisesFromDisk() {
        guard FileManager.default.fileExists(atPath: remoteExercisesURL.path) else { return }
        do {
            let data = try Data(contentsOf: remoteExercisesURL)
            let decoded = try JSONDecoder().decode([ExerciseAPIModel].self, from: data)
            self.remoteExercises = decoded
            self.isOfflineFallback = !decoded.isEmpty
        } catch {
            print("Failed to load cached remote exercises: \(error)")
        }
    }

    // MARK: - ExerciseDB networking

    func fetchExercises() {
        guard let url = URL(string: "https://exercisedb.p.rapidapi.com/exercises?limit=20") else {
            return
        }

        isLoadingRemote = true
        remoteErrorMessage = nil
        isOfflineFallback = false

        Task {
            do {
                var request = URLRequest(url: url)
                // TODO: insert your real RapidAPI key:
                request.setValue("YOUR_RAPIDAPI_KEY_HERE", forHTTPHeaderField: "X-RapidAPI-Key")
                request.setValue("exercisedb.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")

                let (data, _) = try await URLSession.shared.data(for: request)
                let decoded = try JSONDecoder().decode([ExerciseAPIModel].self, from: data)

                self.remoteExercises = decoded
                self.isLoadingRemote = false
                self.remoteErrorMessage = nil
                self.isOfflineFallback = false

                self.saveRemoteExercisesToDisk(decoded)

                let now = Date()
                UserDefaults.standard.set(now.timeIntervalSince1970, forKey: "lastExerciseSyncDate")
                self.lastSyncText = Self.format(date: now)
            } catch {
                self.remoteErrorMessage = "Could not load exercises from network. Showing cached data if available."
                self.isLoadingRemote = false
                self.loadCachedRemoteExercisesFromDisk()
            }
        }
    }

    // MARK: - UserDefaults: last sync

    private func loadLastSyncFromDefaults() {
        let ts = UserDefaults.standard.double(forKey: "lastExerciseSyncDate")
        guard ts > 0 else { return }
        let date = Date(timeIntervalSince1970: ts)
        lastSyncText = Self.format(date: date)
    }

    private static func format(date: Date) -> String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df.string(from: date)
    }
}
