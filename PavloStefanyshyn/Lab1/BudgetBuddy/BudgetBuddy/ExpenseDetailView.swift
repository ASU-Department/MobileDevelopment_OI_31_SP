//
//  ExpenseDetailView.swift
//  BudgetBuddy
//
//  Created by Nill on 10.11.2025.
//

import SwiftUI

struct ExpenseDetailView: UIViewControllerRepresentable {
    let expense: Expense
    
    func makeUIViewController(context: Context) -> ExpenseDetailViewController {
        let controller = ExpenseDetailViewController()
        controller.expense = expense
        return controller
    }
    
    func updateUIViewController(_ uiViewController: ExpenseDetailViewController, context: Context) {
        uiViewController.expense = expense
    }
}
