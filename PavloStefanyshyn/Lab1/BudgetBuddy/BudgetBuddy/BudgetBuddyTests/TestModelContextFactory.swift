//
//  TestModelContextFactory.swift
//  BudgetBuddy
//
//  Created by Nill on 16.12.2025.
//

import SwiftData
@testable import BudgetBuddy

@MainActor
enum TestModelContextFactory {

    static func makeContext() -> ModelContext {
        let schema = Schema([
            ExpenseEntity.self
        ])

        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: true
        )

        let container = try! ModelContainer(
            for: schema,
            configurations: [configuration]
        )

        return ModelContext(container)
    }
}
