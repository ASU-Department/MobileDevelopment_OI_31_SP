//
//  WorkoutViewModel.swift
//  lab1
//
//  Created by A-Z pack group on 02.11.2025.
//
import Foundation
import Combine

@MainActor
final class WorkoutViewModel: ObservableObject {
    @Published var workoutName: String = ""
    @Published var exercises: [ExerciseItem] = []
    @Published var intensity: Double = 0.5
    
    @Published var showingAlert: Bool = false
    @Published var lastSaveMessage: String = ""
    @Published var workouts: [Workout] = []
    
    @Published var remoteExercises: [ExerciseAPIModel] = []
    @Published var isLoadingRemote: Bool = false
    @Published var remoteErrorMessage: String? = nil
    @Published var isOfflineFallback: Bool = false
    @Published var lastSyncText: String? = nil
    
    private let repository: WorkoutRepository
    
    init(repository: WorkoutRepository = DefaultWorkoutRepository()) {
        self.repository = repository
    }
    
    // MARK: - Local workouts
    
    func loadInitialData() {
        Task {
            do {
                let stored = try await repository.loadWorkouts()
                self.workouts = stored
            } catch {
                print("⚠️ Failed to load workouts:", error)
            }
        }
    }
    
    func addExercise() {
        let baseName = workoutName.isEmpty ? "Exercise" : workoutName
        exercises.append(ExerciseItem(name: baseName, sets: 3, reps: 10))
    }
    
    func addExerciseFromRemote(_ remote: ExerciseAPIModel) {
        let name = remote.name
        exercises.append(ExerciseItem(name: name, sets: 3, reps: 10))
    }
    
    func deleteExercise(at offsets: IndexSet) {
        exercises.remove(atOffsets: offsets)
    }
    
    func deleteWorkout(at offsets: IndexSet) {
        workouts.remove(atOffsets: offsets)
        Task {
            do {
                try await repository.saveWorkouts(workouts)
            } catch {
                print("⚠️ Failed to save workouts after delete:", error)
            }
        }
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
        
        lastSaveMessage = "Saved \"\(workoutName)\" with \(exercises.count) exercise(s)."
        workoutName = ""
        exercises.removeAll()
        intensity = 0.5
        showingAlert = true
        
        Task {
            do {
                try await repository.saveWorkouts(workouts)
            } catch {
                print("⚠️ Failed to save workouts:", error)
            }
        }
    }
    
    // MARK: - Remote exercises
    
    func fetchExercises() {
        isLoadingRemote = true
        remoteErrorMessage = nil
        isOfflineFallback = false
        
        Task {
            do {
                let remote = try await repository.fetchRemoteExercises()
                self.remoteExercises = remote
                self.isLoadingRemote = false
                self.remoteErrorMessage = nil
                self.isOfflineFallback = false
                
                try await repository.saveCachedRemoteExercises(remote)
                
                let now = Date()
                UserDefaults.standard.set(
                    now.timeIntervalSince1970,
                    forKey: "lastExerciseSyncDate"
                )
                self.lastSyncText = Self.format(date: now)
            } catch {
                print("❌ Network error:", error)
                self.isLoadingRemote = false
                self.remoteErrorMessage = "Network error: \(error.localizedDescription)"
                
                do {
                    let cached = try await repository.loadCachedRemoteExercises()
                    self.remoteExercises = cached
                    self.isOfflineFallback = true
                } catch {
                    print("⚠️ No cached remote exercises:", error)
                }
            }
        }
    }
    
    private static func format(date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .short
        return f.string(from: date)
    }
}
