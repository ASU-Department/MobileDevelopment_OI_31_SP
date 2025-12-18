//
//  Requests.swift
//  BudgetBuddy
//
//  Created by Nill on 26.10.2025.
//

import SwiftUI
import Charts

struct CategoryExpense: Identifiable {
    let id = UUID()
    let category: String
    let amount: Double
}

struct RequestsView: View {
    let expenses = [
        CategoryExpense(category: "Food", amount: 230),
        CategoryExpense(category: "Travel", amount: 150),
        CategoryExpense(category: "Bills", amount: 320),
        CategoryExpense(category: "Shopping", amount: 90)
    ]
    
    var total: Double {
        expenses.map { $0.amount }.reduce(0, +)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Monthly Total: \(String(format: "%.2f ₴", total))")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    
                    Divider()
                    
                    ForEach(expenses) { item in
                        HStack {
                            Text(item.category)
                            Spacer()
                            Text("\(String(format: "%.2f ₴", item.amount))")
                                .bold()
                        }
                        .padding(.horizontal)
                    }
                    
                    Chart(expenses) { item in
                        BarMark(
                            x: .value("Category", item.category),
                            y: .value("Amount", item.amount)
                        )
                    }
                    .frame(height: 250)
                    .padding()
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Detailed Information")
                            .font(.headline)
                        Text("This section could include weekly breakdowns, spending patterns, and trends.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("Analysis")
        }
    }
}
