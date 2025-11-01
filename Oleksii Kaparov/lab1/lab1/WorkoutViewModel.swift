//
//  WorkoutViewModel.swift
//  lab1
//
//  Created by A-Z pack group on 25.10.2025.
//

import Foundation
import Combine
import SwiftUI

final class WorkoutViewModel: ObservableObject {
    @Published var workoutName: String = ""
    @Published var exercises: [ExerciseItem] = []
    @Published var showingAlert: Bool = false
    @Published var workouts: [Workout] = []
    @Published var lastSaveMessage: String = ""
    
    func addExercise() {
        let baseName = workoutName.isEmpty ? "Exercise" : workoutName
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
        
        let newWorkout = Workout(name: workoutName, exercises: exercises)
        workouts.append(newWorkout)
        
        lastSaveMessage = "Saved \"\(workoutName)\" with \(exercises.count) exercise(s)."
        workoutName = ""
        exercises.removeAll()
        showingAlert = true
    }
    
    func deleteWorkout(at offsets: IndexSet) {
        workouts.remove(atOffsets: offsets)
    }
}
