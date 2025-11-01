//
//  WorkoutHeader.swift
//  lab1
//
//  Created by A-Z pack group on 25.10.2025.
//

import Foundation

import SwiftUI

struct WorkoutHeader: View {
    @Binding var workoutName: String
    
    var body: some View {
        TextField("Enter workout name or exercise", text:$workoutName)
            .textFieldStyle(.roundedBorder)
            .padding(.horizontal)
            .accessibilityIdentifier("workoutNameField")
    }
}
