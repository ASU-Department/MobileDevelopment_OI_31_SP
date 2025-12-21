//
//  ExpenseRepository.swift
//  BudgetBuddy
//
//  Created by Nill on 12.12.2025.
//

import Foundation
import SwiftData

protocol ExpenseRepositoryProtocol {
    func loadLocalExpenses(context: ModelContext) throws -> [ExpenseEntity]
    func addExpense(_ expense: ExpenseEntity, context: ModelContext) throws
    func deleteExpense(_ expense: ExpenseEntity, context: ModelContext) throws
    func fetchAndReplaceFromRemote(context: ModelContext) async throws -> [ExpenseEntity]
}

@MainActor
final class ExpenseRepository: ExpenseRepositoryProtocol {

    private let network: NetworkManager
    private let persistence = PersistenceService()

    init(network: NetworkManager = .shared) {
        self.network = network
    }

    func loadLocalExpenses(context: ModelContext) throws -> [ExpenseEntity] {
        let fd = FetchDescriptor<ExpenseEntity>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        return try context.fetch(fd)
    }

    func addExpense(_ expense: ExpenseEntity, context: ModelContext) throws {
        try persistence.insert(expense, context: context)
    }

    func deleteExpense(_ expense: ExpenseEntity, context: ModelContext) throws {
        try persistence.delete(expense.id, context: context)
    }

    func fetchAndReplaceFromRemote(context: ModelContext) async throws -> [ExpenseEntity] {
        let posts = try await network.fetchSampleRemotePosts()

        let newEntities = posts.prefix(10).map {
            ExpenseEntity(
                title: $0.title.capitalized,
                amount: Double($0.id) * 10,
                priority: Double.random(in: 0...1),
                date: Date()
            )
        }

        try persistence.replaceAll(newEntities, context: context)
        return newEntities
    }
}
