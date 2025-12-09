//
//  SavedWorkoutsView.swift
//  lab1
//
//  Created by A-Z pack group on 02.11.2025.
//
import SwiftUI

struct SavedWorkoutsView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        List {
            ForEach(viewModel.workouts) { workout in
                Button {
                    coordinator.openWorkoutDetail(workout)
                } label: {
                    VStack(alignment: .leading) {
                        Text(workout.name)
                            .font(.headline)
                        Text("\(workout.exercises.count) exercise(s) · \(Int(workout.intensity * 100))%")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onDelete { indexSet in
                Task { @MainActor in
                    viewModel.deleteExercise(at: indexSet)
                }
            }
        }
        .navigationTitle("Saved Workouts")
        .toolbar {
            EditButton()
        }
    }
}
