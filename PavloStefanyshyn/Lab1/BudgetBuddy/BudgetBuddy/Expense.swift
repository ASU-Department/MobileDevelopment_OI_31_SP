//
//  Expense.swift
//  BudgetBuddy
//
//  Created by Nill on 03.11.2025.
//

import Foundation

struct Expense: Identifiable {
    let id = UUID()
    let title: String
    let amount: Double
    let priority: Double
    let date: Date
}
