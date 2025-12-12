//
//  AppCoordinator.swift
//  lab1
//
//  Created by A-Z pack group on 09.12.2025.
//

import Foundation
import SwiftUI

final class AppCoordinator: ObservableObject {
    let workoutViewModel: WorkoutViewModel
    
    @Published var showSavedWorkouts: Bool = false
    @Published var selectedWorkout: Workout? = nil
    @Published var showWorkoutDetail: Bool = false
    
    init(workoutViewModel: WorkoutViewModel) {
        self.workoutViewModel = workoutViewModel
    }
    
    // MARK: - Navigation API
    
    func openSavedWorkouts() {
        showSavedWorkouts = true
    }
    
    func openWorkoutDetail(_ workout: Workout) {
        selectedWorkout = workout
        showWorkoutDetail = true
    }
    
    func closeWorkoutDetail() {
        showWorkoutDetail = false
        selectedWorkout = nil
    }
}
