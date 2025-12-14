//
//  HabitListViewModel.swift
//  habitBuddy
//
//  Created by  User on 14.12.2025.
//

import Foundation
import Combine

@MainActor
final class HabitListViewModel: ObservableObject {

    @Published var habits: [Habit] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    let repository: HabitRepositoryProtocol

    init(repository: HabitRepositoryProtocol) {
        self.repository = repository
    }

    func loadHabits() async {
        isLoading = true
        errorMessage = nil

        do {
            let fetched = try await repository.fetchHabits()
            habits = fetched
        } catch {
            errorMessage = "Failed to load habits"
        }
        isLoading = false
    }

    func deleteHabit(_ habit: Habit) {
        Task {
            do {
                try await repository.deleteHabit(habit)
                await loadHabits()
            } catch {
                self.errorMessage = "Failed to delete habit"
            }
        }
    }
}
