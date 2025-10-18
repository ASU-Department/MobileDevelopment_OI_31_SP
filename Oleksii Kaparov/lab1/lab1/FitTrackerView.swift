//
//  ContentView.swift
//  lab1
//
//  Created by A-Z pack group on 12.10.2025.
//

import SwiftUI


// Model for an exercise item
struct ExerciseItem: Identifiable {
    let id = UUID() // unique identifier for each exrcise
    var name: String // Name of the exercise
    var sets: Int // Number of sets
    var reps: Int // Number of repetitions per set
}
// Main content view of the app
struct ContentView: View {
    // State variables for managing data
    @State private var workoutName: String = "" // Store the workout name
    @State private var exercises: [ExerciseItem] = [
        ExerciseItem(name: "Push up", sets: 3, reps: 15),
        ExerciseItem(name: "Squat", sets: 3, reps: 20)
    ]
    @State private var showingAlert = false
    
   
    var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                // Text field for entering the workout name
                TextField("Enter workout name", text: $workoutName)
                    .textFieldStyle(.roundedBorder)  // Style the text field
                    .padding()

                // List to display exercises
                List {
                    ForEach(exercises) { exercise in
                        HStack {
                            Text(exercise.name)  // Display exercise name
                            Spacer()
                            Text("\(exercise.sets) sets x \(exercise.reps) reps")  // Display sets and reps
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .onDelete(perform: deleteExercise)  // Delete exercise from the list
                }

                // Button to add a new exercise
                Button(action: addExercise) {
                    Text("Add Exercise")
                        .fontWeight(.semibold)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

                // Button to save the workout
                Button(action: saveWorkout) {
                    Text("Save Workout")
                        .fontWeight(.semibold)
                        .padding()
                        .background(workoutName.isEmpty ? Color.gray : Color.green)  // Button is green if workout name is provided
                        .foregroundColor(.white)
                        .cornerRadius(7)
                }
                .disabled(workoutName.isEmpty)  // Disable save button if no name is entered
                .padding()
            }
            .padding()// Add padding around the entire layout
            .alert(isPresented: $showingAlert){
                Alert(
                    title: Text("Work"), message: Text("Workout '\(workoutName)'saved with \(exercises.count) exercise "), dismissButton: .default(Text("OK"))
                )
            }
    }
    
    // Method to add a new exercise to the list
    func addExercise(){
        exercises.append(ExerciseItem(name: "\(workoutName)", sets: 3, reps: 10))
    }
    // Method to delete an exercise from the list
    func deleteExercise(at offsets: IndexSet){
        exercises.remove(atOffsets: offsets)
    }
    // Method to save the workout
    func saveWorkout(){
        showingAlert = true
    }
    
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
