//
//  FitTrackerView.swift
//  lab1
//
//

import SwiftUI

struct FitTrackerView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    
    @AppStorage("preferredIntensity") private var preferredIntensity: Double = 0.5
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            WorkoutHeader(workoutName: $viewModel.workoutName)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Intensity")
                        .font(.headline)
                    Spacer()
                    if let lastSync = viewModel.lastSyncText {
                        Text("Last sync: \(lastSync)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                
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
                
                Section(header: Text("Suggested from ExerciseDB").font(.headline)) {
                    if viewModel.isLoadingRemote {
                        HStack {
                            ProgressView()
                            Text("Loading exercises…")
                        }
                    } else if let error = viewModel.remoteErrorMessage {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(error)
                                .foregroundColor(.red)
                            Button("Retry") {
                                viewModel.fetchExercises()
                            }
                        }
                    } else if viewModel.remoteExercises.isEmpty {
                        Text("No remote exercises yet.")
                            .foregroundColor(.secondary)
                    } else {
                        if viewModel.isOfflineFallback {
                            Text("Offline: showing last cached exercises")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        ForEach(viewModel.remoteExercises.prefix(20)) { ex in
                            Button {
                                viewModel.addExerciseFromRemote(ex)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(ex.name)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .refreshable {
                viewModel.fetchExercises()
            }
            
            // Кнопки дій
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
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(
                title: Text("Workout"),
                message: Text(viewModel.lastSaveMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .toolbar {
            NavigationLink(
                destination: SavedWorkoutsView(viewModel: viewModel)
            ) {
                Label("Saved", systemImage: "list.bullet.rectangle")
            }
        }
        .onAppear {
            if viewModel.intensity == 0.5 {
                viewModel.intensity = preferredIntensity
            }
            
            if viewModel.remoteExercises.isEmpty && !viewModel.isLoadingRemote {
                viewModel.fetchExercises()
            }
        }
        .onChange(of: viewModel.intensity) { newValue in
            preferredIntensity = newValue
        }
    }
}
