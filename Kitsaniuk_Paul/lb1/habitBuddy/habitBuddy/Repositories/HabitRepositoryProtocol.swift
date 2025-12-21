//
//  HabitRepositoryProtocol.swift
//  habitBuddy
//
//  Created by  User on 14.12.2025.
//

import Foundation

protocol HabitRepositoryProtocol {
    func fetchHabits() async throws -> [Habit]
    func addHabit(name: String, desc: String) async throws
    func updateHabit(_ habit: Habit) async throws
    func deleteHabit(_ habit: Habit) async throws
}
