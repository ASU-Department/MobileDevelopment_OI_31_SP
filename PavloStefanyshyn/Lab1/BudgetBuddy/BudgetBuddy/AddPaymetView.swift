//
//  AddPaymet.swift
//  BudgetBuddy
//
//  Created by Nill on 26.10.2025.
//

import SwiftUI
import SwiftData

struct PrioritySlider: UIViewRepresentable {
    @Binding var value: Double
    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        return slider
    }
    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(value)
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(value: $value)
    }
    class Coordinator: NSObject {
        var value: Binding<Double>
        init(value: Binding<Double>) {
            self.value = value
        }
        @objc func valueChanged(_ sender: UISlider) { value.wrappedValue = Double(sender.value)
        }
    }
}

struct AddPaymetView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var amount: String = ""
    @State private var priority: Double = 0.5
    @State private var showValidationAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Expense Details")) {
                TextField("Title", text: $title)
                    .textInputAutocapitalization(.words)
                
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                
                VStack(alignment: .leading) {
                    Text("Priority: \(Int(priority * 100))%")
                    PrioritySlider(value: $priority)
                        .frame(height: 40)
                }
                .padding(.vertical, 5)
            }
            
            Section {
                Button("Save Expense") {
                    guard let amountValue = Double(amount), !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                        showValidationAlert = true
                        return
                    }
                    let newExpense = ExpenseEntity(title: title, amount: amountValue, priority: priority, date: Date())
                    context.insert(newExpense)
                    do {
                        try context.save()
                        dismiss()
                    } catch {
                        // handle save error (alert)
                        print("Save error: \(error)")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
        }
        .navigationTitle("Add Expense")
        .alert("Validation error", isPresented: $showValidationAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please enter a title and a valid amount.")
        }
    }
}

