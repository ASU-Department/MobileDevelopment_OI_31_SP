import Foundation
import SwiftUI

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
        .padding(.vertical, 4)
    }
}
