//
//  Index.swift
//  BudgetBuddy
//
//  Created by Nill on 26.10.2025.
//

import SwiftUI



struct IndexView: View {
    @State private var expenses: [Expense] = []
    private var totalAmount: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("USD: 39.50 ₴")
                        Text("EUR: 42.80 ₴")
                    }
                    .font(.headline)
                    .padding()
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("💰 Total spent: \(totalAmount, specifier: "%.2f") ₴")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    if expenses.isEmpty {
                        Text("No expenses yet.")
                            .foregroundColor(.secondary)
                    } else {
                        VStack(alignment: .leading) {
                            Text("Recent expenses:")
                                .font(.headline)
                            
                            ForEach(expenses.prefix(3)) { expense in
                                NavigationLink(destination: ExpenseDetailView(expense: expense)) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(expense.title)
                                                .font(.body)
                                            Text(expense.date, style: .date)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Text(String(format: "%.2f ₴", expense.amount))
                                    }
                                }
                                .padding(.vertical, 5)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: AddPaymetView(expenses: $expenses)) {
                        Text("➕ Add New Expense")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .navigationTitle("My Expenses")
            }
        }
    }
}
