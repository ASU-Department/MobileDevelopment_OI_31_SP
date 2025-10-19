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
    var reps: Int // Number of repetition per set
}

// Header subview demonstrating @Binding
// This view allows editing the workout name while syncing directly with the parent ContentView's @State variable.
struct WorkoutHeader: View {
    @Binding var workoutName: String
    
    var body: some View {
        TextField("Enter workout name or exercise", text:$workoutName)
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal)
        }
        
    }

// Row subview demonstrating @Binding to an item
// Each row allows editing of an ExerciseItem through a binding to the parent exercises array.
struct ExerciseRow: View {
    @Binding var exercise: ExerciseItem // Bound to a single exercise item
   var body: some View {
       VStack(alignment: .leading, spacing: 10){
           // Editable name field for the exercise
           TextField("Exercise name", text: $exercise.name)
               .font(.headline)
           // Stepper controls for adjusting sets and reps dynamically
           HStack{
               Stepper("Sets: \(exercise.sets)", value: $exercise.sets, in: 1...10)
               Spacer()
               Stepper("Reps: \(exercise.reps)", value: $exercise.reps, in: 1...50)
           }
       }
       
    
}
    
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
                // Mark: -Header section
                WorkoutHeader(workoutName: $workoutName)

                // Mark: -Exercises List
                List {
                    ForEach($exercises) { $exercise in
                        ExerciseRow(exercise: $exercise) // Each row edits directly
                    }
                    .onDelete(perform: deleteExercise)  // Enable swipe-to-delete
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
                .padding(.horizontal)

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
                .padding(.horizontal)
            }
            .padding(.top)// Add padding around the entire layout
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
