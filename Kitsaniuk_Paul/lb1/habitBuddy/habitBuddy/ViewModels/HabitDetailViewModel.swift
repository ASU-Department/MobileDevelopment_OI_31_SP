//
//  HabitDetailViewMode.swift
//  habitBuddy
//
//  Created by  User on 14.12.2025.
//

import Foundation

@MainActor
final class HabitDetailViewModel: ObservableObject {

    @Published var name: String
    @Published var desc: String
    @Published var streak: Int
    @Published var importance: Float

    private let habit: Habit
    private let repository: HabitRepositoryProtocol

    init(habit: Habit, repository: HabitRepositoryProtocol) {
        self.habit = habit
        self.repository = repository

        self.name = habit.name
        self.desc = habit.desc
        self.streak = habit.streak
        self.importance = 50
    }

    func saveChanges() {
        Task {
            do {
                habit.name = name
                habit.desc = desc
                habit.streak = streak
                try await repository.updateHabit(habit)
            } catch {
                print("Failed to update habit")
            }
        }
    }
}
