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
