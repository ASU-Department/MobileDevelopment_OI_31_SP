//
//  FitTrackerView.swift
//  lab1
//
//
import SwiftUI

struct FitTrackerView: View {
    @ObservedObject var viewModel: WorkoutViewModel
    @EnvironmentObject private var coordinator: AppCoordinator
    @AppStorage("preferredIntensity") private var preferredIntensity: Double = 0.5

    init(viewModel: WorkoutViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            WorkoutHeader(workoutName: $viewModel.workoutName)

            VStack(alignment: .leading, spacing: 8) {
                Text("Intensity")
                    .font(.headline)
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

                Section(
                    header: VStack(alignment: .leading, spacing: 4) {
                        Text("Suggested from ExerciseDB").font(.headline)
                        if let lastSync = viewModel.lastSyncText {
                            Text("Last sync: \(lastSync)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                ) {
                    if viewModel.isLoadingRemote {
                        HStack { Spacer(); ProgressView(); Spacer() }
                    } else if let error = viewModel.remoteErrorMessage {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(error).font(.subheadline).foregroundColor(.red)
                            Button("Retry") { viewModel.fetchExercises() }
                        }
                    } else if viewModel.remoteExercises.isEmpty {
                        Text("No remote exercises yet. Pull to refresh.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(viewModel.remoteExercises.prefix(20)) { ex in
                            Button {
                                viewModel.addExerciseFromRemote(ex)
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(ex.name).font(.headline)
                                    Text("\(ex.primaryBodyPart.capitalized) • \((ex.exerciseType ?? "strength").capitalized)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("Equipment: \(ex.primaryEquipment.capitalized)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .refreshable {
                viewModel.fetchExercises()
            }
HStack(spacing: 12) {
                Button {
                    viewModel.addExercise()
                } label: {
                    Text("Add Exercise")
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button {
                    viewModel.saveWorkout()
                } label: {
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
            Button {
                coordinator.openSavedWorkouts()
            } label: {
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
        .onAppear {
            if viewModel.intensity == 0.5 {
                viewModel.intensity = preferredIntensity
            }
        }
        .onChange(of: viewModel.intensity) { newValue in
            preferredIntensity = newValue
        }
    }
}
