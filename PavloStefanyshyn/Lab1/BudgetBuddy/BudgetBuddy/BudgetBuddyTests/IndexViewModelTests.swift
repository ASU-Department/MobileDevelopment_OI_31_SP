//
//  IndexViewModelTests.swift
//  BudgetBuddy
//
//  Created by Nill on 16.12.2025.
//

import XCTest
@testable import BudgetBuddy

@MainActor
final class IndexViewModelTests: XCTestCase {

    func testLoadLocalExpensesSuccess() async {
        let mockRepo = MockExpenseRepository()
        mockRepo.allExpenses  = [
            ExpenseEntity(title: "Coffee", amount: 50)
        ]

        let context = TestModelContextFactory.makeContext()
        let viewModel = IndexViewModel(repository: mockRepo, context: context)

        viewModel.loadLocal()

        XCTAssertEqual(viewModel.expenses.count, 1)
        XCTAssertEqual(viewModel.totalAmount, 50)
    }

    func testRefreshFailureSetsError() async {
        let mockRepo = MockExpenseRepository()
        mockRepo.shouldFail = true

        let context = TestModelContextFactory.makeContext()
        let viewModel = IndexViewModel(repository: mockRepo, context: context)

        await viewModel.refresh()

        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }
}
