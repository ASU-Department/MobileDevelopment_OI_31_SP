//
//  HabitStorageActor.swift
//  habitBuddy
//
//  Created by  User on 14.12.2025.
//

import SwiftData
import Foundation

actor HabitStorageActor {

    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchHabits() throws -> [Habit] {
        let descriptor = FetchDescriptor<Habit>(
            sortBy: [SortDescriptor(\.name)]
        )
        return try modelContext.fetch(descriptor)
    }

    func insertHabit(name: String, desc: String) throws {
        let habit = Habit(name: name, desc: desc, streak: 0)
        modelContext.insert(habit)
        try modelContext.save()
    }

    func updateHabit(_ habit: Habit) throws {
        try modelContext.save()
    }

    func deleteHabit(_ habit: Habit) throws {
        modelContext.delete(habit)
        try modelContext.save()
    }
}
