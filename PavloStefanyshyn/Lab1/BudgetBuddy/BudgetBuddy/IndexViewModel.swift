//
//  IndexViewModel.swift
//  BudgetBuddy
//
//  Created by Nill on 12.12.2025.
//

import Foundation
import SwiftData
import Combine

@MainActor
final class IndexViewModel: ObservableObject {

    @Published var expenses: [ExpenseEntity] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    @Published var autoRefreshEnabled: Bool = false

    private let repository: ExpenseRepositoryProtocol
    private let context: ModelContext

    init(repository: ExpenseRepositoryProtocol, context: ModelContext) {
        self.repository = repository
        self.context = context
    }

    // MARK: - Lifecycle

    func onAppear() async {
        if autoRefreshEnabled {
            await refresh()
        } else {
            loadLocal()
        }
    }

    // MARK: - Data loading

    func loadLocal() {
        do {
            expenses = try repository.loadLocalExpenses(context: context)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func refresh() async {
        isLoading = true
        defer { isLoading = false }

        do {
            expenses = try await repository.fetchAndReplaceFromRemote(context: context)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Actions

    func delete(_ expense: ExpenseEntity) async {
        do {
            try await repository.deleteExpense(expense, context: context)
            loadLocal()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Computed

    var totalAmount: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
}
