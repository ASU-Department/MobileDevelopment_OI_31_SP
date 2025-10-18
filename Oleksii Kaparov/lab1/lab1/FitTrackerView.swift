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
        // Text field for entering the workout name
        VStack(alignment: .leading, spacing: 20){
        TextField("Enter workout name",text:$workoutName)
            .textFieldStyle(.roundedBorder) // Style the text field
            .padding()
            
            // List of display exercise
            List{
                ForEach(exrcise){ exrcise in
                    HStack{
                        Text(exrcise.name) // Display exercise name
                        Spacer()
                        Text("\(exrcise.sets) sets x\(exrcise.reps)")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                    
                }
                
            }
            
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
