//
//  Index.swift
//  BudgetBuddy
//
//  Created by Nill on 26.10.2025.
//

import SwiftUI
import SwiftData

struct IndexView: View {
    @StateObject var viewModel: IndexViewModel
    let coordinator: AppCoordinators
    @Environment(\.modelContext) private var modelContext
    @State private var showErrorAlert = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                Text("Total spent: \(viewModel.totalAmount, specifier: "%.2f") ₴")
                    .font(.title2)
                    .fontWeight(.semibold)

                if viewModel.isLoading {
                    ProgressView("Loading…")
                }

                List {
                    ForEach(viewModel.expenses) { e in
                        NavigationLink {
                            ExpenseDetailView(expense: e)
                        } label: {
                            HStack {
                                Text(e.title)
                                Spacer()
                                Text("\(e.amount, specifier: "%.2f") ₴")
                            }
                        }
                    }
                    .onDelete { idx in
                        Task {
                            for i in idx {
                                await viewModel.delete(viewModel.expenses[i])
                            }
                        }
                    }
                }

                NavigationLink {
                    coordinator.makeAddExpenseView(context: modelContext)
                } label: {
                    Text("Add New Expense")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .padding()
            .navigationTitle("My Expenses")
            .task {
                await viewModel.onAppear()
            }
            .refreshable {
                await viewModel.refresh()
            }
            .onAppear {
                viewModel.loadLocal()
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK") { viewModel.errorMessage = nil }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .onChange(of: viewModel.errorMessage) { _, newValue in
                showErrorAlert = newValue != nil
            }
        }
    }
}
