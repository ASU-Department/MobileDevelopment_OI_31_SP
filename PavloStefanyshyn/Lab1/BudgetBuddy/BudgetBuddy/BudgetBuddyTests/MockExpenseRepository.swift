//
//  MockExpenseRepository.swift
//  BudgetBuddy
//
//  Created by Nill on 16.12.2025.
//

import Foundation
import SwiftData
@testable import BudgetBuddy

class MockExpenseRepository: ExpenseRepositoryProtocol {
    private var expenses: [ExpenseEntity] = []

    var allExpenses: [ExpenseEntity] {
        get { expenses }
        set { expenses = newValue }
    }

    var shouldFail: Bool = false

    func loadLocalExpenses(context: ModelContext) throws -> [ExpenseEntity] {
        if shouldFail { throw NSError(domain: "MockError", code: 1) }
        return expenses
    }

    func addExpense(_ expense: ExpenseEntity, context: ModelContext) throws {
        if shouldFail { throw NSError(domain: "MockError", code: 1) }
        expenses.append(expense)
    }

    func deleteExpense(_ expense: ExpenseEntity, context: ModelContext) throws {
        if shouldFail { throw NSError(domain: "MockError", code: 1) }
        expenses.removeAll { $0.id == expense.id }
    }

    func fetchAndReplaceFromRemote(context: ModelContext) async throws -> [ExpenseEntity] {
        if shouldFail { throw NSError(domain: "MockError", code: 1) }
        return []
    }
}



