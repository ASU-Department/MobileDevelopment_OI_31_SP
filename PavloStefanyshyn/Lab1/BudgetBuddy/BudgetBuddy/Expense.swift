//
//  Expense.swift
//  BudgetBuddy
//
//  Created by Nill on 03.11.2025.
//

import Foundation
import SwiftData

@Model
final class ExpenseEntity: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var amount: Double
    var priority: Double
    var date: Date
    
    init(id: UUID = UUID(), title: String, amount: Double, priority: Double = 0.5, date: Date = Date()) {
        self.id = id
        self.title = title
        self.amount = amount
        self.priority = priority
        self.date = date
    }
}
