//
//  Index.swift
//  BudgetBuddy
//
//  Created by Nill on 26.10.2025.
//

import SwiftUI



struct IndexView: View {
    @State private var isShowingAddPayment = false
    @State private var totalExpenses: Double = 324.75
    
    var body: some View {
        NavigationView {
                VStack(spacing: 20) {
                    // інформація про тан курсу долаоа та євро
                    HStack {
                        VStack(alignment: .leading) {
                            Text("USD: 39.50 ₴")
                            Text("EUR: 42.80 ₴")
                        }
                        .font(.headline)
                        .padding()
                        Spacer()
                    }
                    
                    // Загальна сума витрат
                    VStack {
                        Text("Total Expenses")
                            .font(.subheadline)
                        Text(String(format: "%.2f ₴", totalExpenses))
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.red)
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Кнопка додавання витрати
                    
                    Button (action:{
                        isShowingAddPayment.toggle()
                        
                    }){
                        Label("Add Expense", systemImage: "plus.circle.fill")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.9))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .padding(.horizontal)
                    }
                    .sheet(isPresented: $isShowingAddPayment){
                        AddPaymetView()
                    }
                    
                    Spacer()
                }
                .navigationTitle("Payment")
            }
        }
    }

