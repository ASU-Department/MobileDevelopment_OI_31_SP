//
//  ContentView.swift
//  lab1
//
//  Created by A-Z pack group on 12.10.2025.
//

import SwiftUI

public struct ContentView: View {
    @StateObject private var viewModel = WorkoutViewModel()

   public var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {

                WorkoutHeader(workoutName: $viewModel.workoutName)

                Section(header: Text("Exercises").font(.headline).padding(.horizontal)) {
                    List {
                        ForEach($viewModel.exercises) { $exercise in
                            ExerciseRow(exercise: $exercise)
                        }
                        .onDelete { indexSet in                  // ✅ call with label
                            viewModel.deleteExercise(at: indexSet)
                        }
                    }
                    .listStyle(.insetGrouped)
                }

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
            }
            .navigationTitle("Workout Builder")
            .padding(.top)
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(
                    title: Text("Workout"),
                    message: Text(viewModel.lastSaveMessage),   // ✅ now exists
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
