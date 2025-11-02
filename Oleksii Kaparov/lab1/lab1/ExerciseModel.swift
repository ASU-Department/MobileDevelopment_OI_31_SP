import Foundation

struct ExerciseItem: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var sets: Int
    var reps: Int
}
