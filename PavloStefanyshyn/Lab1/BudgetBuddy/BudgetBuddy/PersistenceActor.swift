//
//  PersistenceActor.swift
//  BudgetBuddy
//
//  Created by Nill on 12.12.2025.
//

import Foundation
import SwiftData

actor PersistenceActor {
    
    func insert(_ expense: ExpenseEntity, in context: ModelContext) async throws {
        context.insert(expense)
        try context.save()
    }
    
    func delete(_ id: UUID, in context: ModelContext) async throws {

        let fetch = try context.fetch(FetchDescriptor<ExpenseEntity>(predicate: #Predicate { $0.id == id }))
        if let object = fetch.first {
            context.delete(object)
            try context.save()
        }
    }
    
    func replaceAll(_ items: [ExpenseEntity], in context: ModelContext) async throws {
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

