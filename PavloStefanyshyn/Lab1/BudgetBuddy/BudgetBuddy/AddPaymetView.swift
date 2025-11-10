//
//  AddPaymet.swift
//  BudgetBuddy
//
//  Created by Nill on 26.10.2025.
//

import SwiftUI
import UIKit

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
        
        @objc func valueChanged(_ sender: UISlider) {
            value.wrappedValue = Double(sender.value)
        }
    }
}

struct AddPaymetView: View {
    @Binding var expenses: [Expense]
       
    @State private var title: String = ""
    @State private var amount: String = ""
    @State private var priority: Double = 0.5
    @Environment(\.dismiss) private var dismiss
       
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
                   guard let amountValue = Double(amount), !title.isEmpty else { return }
                   let newExpense = Expense(title: title, amount: amountValue, priority: priority, date: Date())
                   expenses.insert(newExpense, at: 0)
                   dismiss()
               }
               .frame(maxWidth: .infinity)
               .padding()
               .background(Color.green)
               .foregroundColor(.white)
               .cornerRadius(12)
            }
        }
        .navigationTitle("Add Expense")
    }
}
