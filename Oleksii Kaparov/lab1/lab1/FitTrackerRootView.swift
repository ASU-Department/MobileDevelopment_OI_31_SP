//
//  FitTrackerRootView.swift
//  lab1
//
//  Created by A-Z pack group on 18.11.2025.
//
import SwiftUI

struct FitTrackerRootView: View {
    @StateObject private var coordinator: AppCoordinator
    
    init() {
        let vm = WorkoutViewModel()
        _coordinator = StateObject(wrappedValue: AppCoordinator(workoutViewModel: vm))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                FitTrackerView(viewModel: coordinator.workoutViewModel)
                    .environmentObject(coordinator)
                
                NavigationLink(
                    destination: SavedWorkoutsView(viewModel: coordinator.workoutViewModel)
                        .environmentObject(coordinator),
                    isActive: $coordinator.showSavedWorkouts
                ) {
                    EmptyView()
                }
                
                NavigationLink(
                    destination: detailDestination(),
                    isActive: $coordinator.showWorkoutDetail
                ) {
                    EmptyView()
                }
            }
        }
        .onAppear {
            coordinator.workoutViewModel.loadInitialData()
            if coordinator.workoutViewModel.remoteExercises.isEmpty &&
                !coordinator.workoutViewModel.isLoadingRemote {
                coordinator.workoutViewModel.fetchExercises()
            }
        }
    }
    
    @ViewBuilder
    private func detailDestination() -> some View {
        if let workout = coordinator.selectedWorkout {
            WorkoutDetailView(workout: workout)
                .environmentObject(coordinator)
        } else {
            EmptyView()
        }
    }
}
