import SwiftUI

struct WorkoutDetailView: View {
    let workout: Workout
    @State private var showShare = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(workout.name)
                        .font(.largeTitle).bold()
                    Text("Intensity: \(Int(workout.intensity * 100))%")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text("Date: \(workout.date.formatted(date: .abbreviated, time: .shortened))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)

                Divider().padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Exercises").font(.title3).bold()
                    ForEach(workout.exercises) { ex in
                        HStack {
                            Text(ex.name).font(.headline)
                            Spacer()
                            Text("\(ex.sets)x\(ex.reps)")
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .padding(.horizontal)

                Button {
                    showShare = true
                } label: {
                    Label("Share Workout", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .padding(.horizontal)
                
            }
            .padding(.top)
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showShare) {
            ActivityViewControllerRepresentable(items: [shareText()]) { _ in }
        }
    }

    private func shareText() -> String {
        var lines: [String] = []
        lines.append("Workout: \(workout.name)")
        lines.append("Date: \(workout.date.formatted(date: .abbreviated, time: .shortened))")
        lines.append("Intensity: \(Int(workout.intensity * 100))%")
        lines.append("Exercises:")
        for ex in workout.exercises {
            lines.append("• \(ex.name): \(ex.sets) x \(ex.reps)")
        }
        return lines.joined(separator: "\n")
    }
}
