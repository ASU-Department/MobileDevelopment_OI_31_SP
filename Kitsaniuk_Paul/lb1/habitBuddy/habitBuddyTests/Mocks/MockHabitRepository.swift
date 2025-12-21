//
//  MockHabitRepository.swift
//  habitBuddyTests
//
//  Created by  User on 16.12.2025.
//

import Foundation
@testable import habitBuddy

final class MockHabitRepository: HabitRepositoryProtocol {

    var habits: [Habit] = []
    var shouldThrowError: Bool = false
    var delay: UInt64 = 0

    private(set) var fetchCalled = false
    private(set) var addCalled = false
    private(set) var updateCalled = false
    private(set) var deleteCalled = false

    private(set) var updatedHabit: Habit?   // ✅ NEW

    func fetchHabits() async throws -> [Habit] {
        fetchCalled = true
        try await simulateDelay()

        if shouldThrowError {
            throw MockError.testError
        }

        return habits
    }

    func addHabit(name: String, desc: String) async throws {
        addCalled = true
        try await simulateDelay()

        if shouldThrowError {
            throw MockError.testError
        }

        let newHabit = Habit(name: name, desc: desc, streak: 0)
        habits.append(newHabit)
    }

    func updateHabit(_ habit: Habit) async throws {
        updateCalled = true
        updatedHabit = habit            // ✅ NEW
        try await simulateDelay()

        if shouldThrowError {
            throw MockError.testError
        }

        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index] = habit
        }
    }

    func deleteHabit(_ habit: Habit) async throws {
        deleteCalled = true
        try await simulateDelay()

        if shouldThrowError {
            throw MockError.testError
        }

        habits.removeAll { $0.id == habit.id }
    }

    private func simulateDelay() async throws {
        if delay > 0 {
            try await Task.sleep(nanoseconds: delay)
        }
    }
}

enum MockError: Error {
    case testError
}
