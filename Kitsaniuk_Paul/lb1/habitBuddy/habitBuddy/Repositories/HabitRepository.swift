//
//  HabitRepository.swift
//  habitBuddy
//
//  Created by  User on 14.12.2025.
//

import Foundation

final class HabitRepository: HabitRepositoryProtocol {

    private let storageActor: HabitStorageActor

    init(storageActor: HabitStorageActor) {
        self.storageActor = storageActor
    }

    func fetchHabits() async throws -> [Habit] {
        try await storageActor.fetchHabits()
    }

    func addHabit(name: String, desc: String) async throws {
        try await storageActor.insertHabit(name: name, desc: desc)
    }

    func updateHabit(_ habit: Habit) async throws {
        try await storageActor.updateHabit(habit)
    }

    func deleteHabit(_ habit: Habit) async throws {
        try await storageActor.deleteHabit(habit)
    }
}
