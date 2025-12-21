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
    func addExpense(_ expense: ExpenseEntity, context: ModelContext) async throws
    func deleteExpense(_ expense: ExpenseEntity, context: ModelContext) async throws
    func fetchAndReplaceFromRemote(context: ModelContext) async throws -> [ExpenseEntity]
}

final class ExpenseRepository: ExpenseRepositoryProtocol {
    private let network: NetworkManager
    private let actor = PersistenceActor()
    
    init(network: NetworkManager = .shared) {
        self.network = network
    }
    
    func loadLocalExpenses(context: ModelContext) throws -> [ExpenseEntity] {

        let fd = FetchDescriptor<ExpenseEntity>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        return try context.fetch(fd)
    }
    
    func addExpense(_ expense: ExpenseEntity, context: ModelContext) async throws {
        try await actor.insert(expense, in: context)
    }

    func deleteExpense(_ expense: ExpenseEntity, context: ModelContext) async throws {
        try await actor.delete(expense.id, in: context)
    }

    func fetchAndReplaceFromRemote(context: ModelContext) async throws -> [ExpenseEntity] {
        let posts = try await network.fetchSampleRemotePosts()
        var newEntities: [ExpenseEntity] = []
        for post in posts.prefix(10) {
            let e = ExpenseEntity(title: post.title.capitalized, amount: Double(post.id) * 10.0, priority: Double.random(in: 0...1), date: Date())
            newEntities.append(e)
        }
        try await actor.replaceAll(newEntities, in: context)
        return newEntities
    }
}
