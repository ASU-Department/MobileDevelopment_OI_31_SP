//
//  AddPaymet.swift
//  BudgetBuddy
//
//  Created by Nill on 26.10.2025.
//

import SwiftUI

struct AddPaymetView: View {
    @ObservedObject var viewModel: AddExpenseViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            TextField("Title", text: $viewModel.title)
            TextField("Amount", text: $viewModel.amountText)
                .keyboardType(.decimalPad)

            VStack {
                Text("Priority: \(Int(viewModel.priority * 100))%")
                Priorityslider(value: $viewModel.priority)
            }

            Button("Save") {
                Task {
                    if await viewModel.save() {
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle("Add Expense")
        .alert("Validation error", isPresented: $viewModel.showValidationError) {
            Button("OK", role: .cancel) {}
        }
    }
}
