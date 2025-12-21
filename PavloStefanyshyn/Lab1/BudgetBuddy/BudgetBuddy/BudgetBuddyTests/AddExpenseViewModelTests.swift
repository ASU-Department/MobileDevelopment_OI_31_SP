//
//  AddExpenseViewModelTests.swift
//  BudgetBuddy
//
//  Created by Nill on 16.12.2025.
//

import Testing
@testable import BudgetBuddy

@MainActor
struct AddExpenseViewModelTests {

    @Test
    func invalidAmountFailsValidation() async {
        let mockRepo = MockExpenseRepository()
        let context = TestModelContextFactory.makeContext()
        let viewModel = AddExpenseViewModel(repository: mockRepo, context: context)

        viewModel.title = "Test"
        viewModel.amountText = ""

        let result = await viewModel.save()

        #expect(result == false)
        #expect(viewModel.showValidationError == true)
        #expect(viewModel.saveError == nil)
    }
    

    @Test
    func validExpenseIsSaved() async {
        let mockRepo = MockExpenseRepository()
        let context = TestModelContextFactory.makeContext()
        let viewModel = AddExpenseViewModel(repository: mockRepo, context: context)

        viewModel.title = "Lunch"
        viewModel.amountText = "120"

        let result = await viewModel.save()

        #expect(result == true)
        #expect(mockRepo.allExpenses.count == 1)
    }
}
