//
//  PersistenceActor.swift
//  BudgetBuddy
//
//  Created by Nill on 12.12.2025.
//

import Foundation
import SwiftData

@MainActor
final class PersistenceService {

    func insert(_ expense: ExpenseEntity, context: ModelContext) throws {
        context.insert(expense)
        try context.save()
    }

    func delete(_ id: UUID, context: ModelContext) throws {
        let fetch = try context.fetch(
            FetchDescriptor<ExpenseEntity>(predicate: #Predicate { $0.id == id })
        )
        if let object = fetch.first {
            context.delete(object)
            try context.save()
        }
    }

    func replaceAll(_ items: [ExpenseEntity], context: ModelContext) throws {
        let existing = try context.fetch(FetchDescriptor<ExpenseEntity>())
        for obj in existing {
            context.delete(obj)
        }
        for item in items {
            context.insert(item)
        }
        try context.save()
    }
}

