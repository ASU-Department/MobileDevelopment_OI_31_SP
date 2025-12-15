//
//  AddExpenseViewModel.swift
//  BudgetBuddy
//
//  Created by Nill on 12.12.2025.
//

import Foundation
import SwiftData
import Combine

@MainActor
final class AddExpenseViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var amountText: String = ""
    @Published var priority: Double = 0.5
    @Published var showValidationError: Bool = false
    @Published var saveError: String?
    private let repository: ExpenseRepositoryProtocol
    private let context: ModelContext
    
    init(repository: ExpenseRepositoryProtocol, context: ModelContext) {
        self.repository = repository
        self.context = context
    }
    
    func save() async -> Bool {
        guard let amount = Double(amountText), !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showValidationError = true
            return false
        }
        let expense = ExpenseEntity(title: title, amount: amount, priority: priority, date: Date())
        do {
            try await repository.addExpense(expense, context: context)
            return true
        } catch {
            saveError = error.localizedDescription
            return false
        }
    }
}
