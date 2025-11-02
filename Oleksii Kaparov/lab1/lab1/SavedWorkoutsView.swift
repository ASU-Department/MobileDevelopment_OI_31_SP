import SwiftUI

struct SavedWorkoutsView: View {
    @EnvironmentObject var viewModel: WorkoutViewModel

    var body: some View {
        List {
            ForEach(viewModel.workouts) { workout in
                NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                    VStack(alignment: .leading) {
                        Text(workout.name).font(.headline)
                        Text("\(workout.exercises.count) exercise(s) · \(Int(workout.intensity * 100))%")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .onDelete(perform: viewModel.deleteWorkout)
        }
        .navigationTitle("Saved Workouts")
        .toolbar { EditButton() }
    }
}
