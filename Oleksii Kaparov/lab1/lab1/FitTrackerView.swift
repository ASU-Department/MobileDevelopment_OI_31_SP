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
    @State private var exrcise: [ExerciseItem] = [
        ExerciseItem(name: "Push up", sets: 3, reps: 15),
        ExerciseItem(name: "Squat", sets: 3, reps: 20)
    ]
    
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
