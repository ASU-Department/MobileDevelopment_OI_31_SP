//
//  Index.swift
//  BudgetBuddy
//
//  Created by Nill on 26.10.2025.
//

// IndexView.swift
import SwiftUI
import SwiftData

struct IndexView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \ExpenseEntity.date, order: .reverse)
    private var expensesEntities: [ExpenseEntity]

    
    @State private var isLoading = false
    @State private var alertMessage: String?
    @State private var showAlert = false
    @State private var autoRefresh: Bool = UserDefaults.standard.bool(forKey: "autoRefreshEnabled")
    
    private var totalAmount: Double {
        expensesEntities.reduce(0) { $0 + $1.amount }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("USD: 39.50 ₴")
                        Text("EUR: 42.80 ₴")
                    }
                    .font(.headline)
                    .padding()
                    Spacer()
                }

                VStack(alignment: .leading, spacing: 16) {
                    Text("Total spent: \(totalAmount, specifier: "%.2f") ₴")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    if isLoading {
                        ProgressView("Loading…")
                            .padding()
                    }
                    
                    if expensesEntities.isEmpty && !isLoading {
                        Text("No expenses yet.")
                            .foregroundColor(.secondary)
                    } else {
                        List {
                            ForEach(expensesEntities) { e in
                                NavigationLink(destination: ExpenseDetailView(expense: ExpenseEntity(title: e.title, amount: e.amount, priority: e.priority, date: e.date))) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(e.title)
                                                .font(.body)
                                            Text(e.date, style: .date)
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Text(String(format: "%.2f ₴", e.amount))
                                    }
                                }
                            }
                            .onDelete(perform: deleteItems)
                        }
                        .listStyle(.plain)
                        .frame(maxHeight: 300)
                        .refreshable {
                            await fetchFromAPI()
                        }
                    }
                    
                    NavigationLink(destination: AddPaymetView()) {
                        Text("Add New Expense")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    
                    Toggle("Auto refresh on launch", isOn: $autoRefresh)
                        .onChange(of: autoRefresh) { newValue in
                            UserDefaults.standard.set(newValue, forKey: "autoRefreshEnabled")
                        }
                    
                    Text("Last update: \(UserDefaults.standard.string(forKey: "lastUpdate") ?? "never")")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding()
            }
            .navigationTitle("My Expenses")
            .task {
                if autoRefresh {
                    await fetchFromAPI()
                }
            }
            .alert("Error", isPresented: $showAlert, actions: { Button("OK", role: .cancel) {} }, message: {
                Text(alertMessage ?? "Unknown error")
            })
        }
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for idx in offsets {
            let e = expensesEntities[idx]
            context.delete(e)
        }
        do {
            try context.save()
        } catch {
            print("Delete error: \(error)")
        }
    }
    
    // MARK: - Network + persistence logic
    @MainActor
    private func fetchFromAPI() async {
        isLoading = true
        do {
            let posts = try await NetworkManager.shared.fetchSampleExpenses()
            
            for e in expensesEntities {
                context.delete(e)
            }
            
            for post in posts.prefix(10) {
                let newExpense = ExpenseEntity(title: post.title.capitalized, amount: Double(post.id) * 10.0, priority: Double.random(in: 0...1), date: Date())
                context.insert(newExpense)
            }
            try context.save()
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            UserDefaults.standard.set(formatter.string(from: Date()), forKey: "lastUpdate")
        } catch {
            alertMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            showAlert = true
        }
        isLoading = false
    }
}
