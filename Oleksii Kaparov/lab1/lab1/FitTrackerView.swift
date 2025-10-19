//
//  ContentView.swift
//  lab1
//
//  Created by A-Z pack group on 12.10.2025.
//

import SwiftUI

struct ExerciseItem: Identifiable {
    let id = UUID()
    var name: String
    var sets: Int
    var reps: Int
}

// This view allows editing the workout name while syncing directly with the parent ContentView's @State variable.
struct WorkoutHeader: View {
    @Binding var workoutName: String
    
    var body: some View {
        TextField("Enter workout name or exercise", text:$workoutName)
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal)
    }
}

// Each row allows editing of an ExerciseItem through a binding to the parent exercises array.
struct ExerciseRow: View {
    @Binding var exercise: ExerciseItem
    var body: some View {
        VStack(alignment: .leading, spacing: 10){
            TextField("Exercise name", text: $exercise.name)
                .font(.headline)
            HStack{
                Stepper("Sets: \(exercise.sets)", value: $exercise.sets, in: 1...10)
                Spacer()
                Stepper("Reps: \(exercise.reps)", value: $exercise.reps, in: 1...50)
            }
        }
    }
}

struct ContentView: View {
    @State private var workoutName: String = ""
    @State private var exercises: [ExerciseItem] = [
        ExerciseItem(name: "Push up", sets: 3, reps: 15),
        ExerciseItem(name: "Squat", sets: 3, reps: 20)
    ]
    @State private var showingAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            WorkoutHeader(workoutName: $workoutName)
            
            List {
                ForEach($exercises) { $exercise in
                    ExerciseRow(exercise: $exercise)
                }
                .onDelete(perform: deleteExercise)  // Enable swipe-to-delete
            }
        
            Button(action: addExercise) {
                Text("Add Exercise")
                    .fontWeight(.semibold)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
        
            Button(action: saveWorkout) {
                Text("Save Workout")
                    .fontWeight(.semibold)
                    .padding()
                    .background(workoutName.isEmpty ? Color.gray : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(7)
            }
            .disabled(workoutName.isEmpty)
            .padding(.horizontal)
        }
        .padding(.top)
        .alert(isPresented: $showingAlert){
            Alert(
                title: Text("Work"), message: Text("Workout '\(workoutName)'saved with \(exercises.count) exercise "), dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func addExercise(){
        exercises.append(ExerciseItem(name: "\(workoutName)", sets: 3, reps: 10))
    }
    
    func deleteExercise(at offsets: IndexSet){
        exercises.remove(atOffsets: offsets)
    }
    
    func saveWorkout(){
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
