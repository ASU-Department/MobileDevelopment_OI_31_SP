//
//  FitTrackerView.swift
//  lab1
//
//  Created by A-Z pack group on 02.11.2025.
//
import SwiftUI

public struct FitTrackerView: View {
    @StateObject private var viewModel = WorkoutViewModel()

    public var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                WorkoutHeader(workoutName: $viewModel.workoutName)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Intensity").font(.headline).padding(.horizontal)
                    HStack {
                        IntensitySliderRepresentable(value: $viewModel.intensity)
                            .frame(height: 40)
                            .padding(.horizontal)
                        Text("\(Int(viewModel.intensity * 100))%")
                            .monospacedDigit()
                            .frame(width: 60, alignment: .trailing)
                            .padding(.trailing)
                    }
                }

                List {
                    Section(header: Text("Exercises").font(.headline)) {
                        ForEach($viewModel.exercises) { $exercise in
                            ExerciseRow(exercise: $exercise)
                        }
                        .onDelete { indexSet in
                            viewModel.deleteExercise(at: indexSet)
                        }
                    }
                }
                .listStyle(.insetGrouped)

                HStack(spacing: 12) {
                    Button(action: viewModel.addExercise) {
                        Text("Add Exercise")
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    Button(action: viewModel.saveWorkout) {
                        Text("Save Workout")
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(viewModel.workoutName.isEmpty ? Color.gray : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(viewModel.workoutName.isEmpty)
                }
                .padding(.horizontal)

                Spacer(minLength: 0)
            }
            .navigationTitle("Workout Builder")
            .padding(.top)
            .toolbar {
                // Keep NavigationView + classic NavigationLink for iOS 15
                NavigationLink(destination: SavedWorkoutsView().environmentObject(viewModel)) {
                    Label("Saved", systemImage: "list.bullet.rectangle")
                }
            }
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(
                    title: Text("Workout"),
                    message: Text(viewModel.lastSaveMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}
