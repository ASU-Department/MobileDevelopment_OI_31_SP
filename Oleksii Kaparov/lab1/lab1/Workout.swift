import Foundation

struct Workout: Identifiable, Hashable{
    let id = UUID()
    var name: String
    var exercises: [ExerciseItem]
    var date: Date = Date()
    var intensity: Double = 0.5
}
