//
//  ExpenseRepositoryTests.swift
//  BudgetBuddy
//
//  Created by Nill on 16.12.2025.
//

import XCTest
import SwiftData
@testable import BudgetBuddy

@MainActor
final class ExpenseRepositoryTests: XCTestCase {

    var context: ModelContext!
    var repository: ExpenseRepository!

    override func setUpWithError() throws {
        let container = try ModelContainer(for: ExpenseEntity.self)
        context = container.mainContext

        repository = ExpenseRepository()
    }

    func testAddExpense() async throws {
        let expense = ExpenseEntity(title: "Test Expense", amount: 100)
        try await repository.addExpense(expense, context: context)
        
        let fetched = try repository.loadLocalExpenses(context: context)
        XCTAssertTrue(fetched.contains { $0.title == "Test Expense" })
    }

    func testDeleteExpense() async throws {
        let expense = ExpenseEntity(title: "To Delete", amount: 50)
        try await repository.addExpense(expense, context: context)

        try await repository.deleteExpense(expense, context: context)
        let fetched = try repository.loadLocalExpenses(context: context)
        XCTAssertFalse(fetched.contains { $0.title == "To Delete" })
    }
}
