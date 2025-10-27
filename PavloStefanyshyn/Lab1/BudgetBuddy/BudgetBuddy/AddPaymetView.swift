//
//  AddPaymet.swift
//  BudgetBuddy
//
//  Created by Nill on 26.10.2025.
//

import SwiftUI

struct AddPaymetView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var expenseName = ""
    @State private var expenseCategory = "Food"
    @State private var expenseAmount = ""
    
    let categories = ["Food", "Travel", "Shopping", "Bills", "Other"]
    
    var body: some View {
        // Спливаюче вікно з формою додавання новї витрати
        NavigationView {
            
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Name", text: $expenseName) //Назва витрати
                    Picker("Category", selection: $expenseCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    } // Вибір категорії із запропонованого списку
                    TextField("Amount", text: $expenseAmount)
                        .keyboardType(.decimalPad) // сума витрати
                }
            }
            .navigationTitle("Add Expense")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        dismiss()
                    }//Збереження нових даних
                }
            }
        }
    }
}
