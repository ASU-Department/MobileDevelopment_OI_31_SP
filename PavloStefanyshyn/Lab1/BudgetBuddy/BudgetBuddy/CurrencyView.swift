//
//  Currency.swift
//  BudgetBuddy
//
//  Created by Nill on 26.10.2025.
//

import SwiftUI

struct Currency: Identifiable {
    let id = UUID()
    let code: String
    let rate: Double
}

struct CurrencyView: View {
    @State private var currencies: [Currency] = []
    @State private var loadedCount = 0
    
    let allCurrencies = [
        Currency(code: "USD", rate: 39.50),
        Currency(code: "EUR", rate: 42.80),
        Currency(code: "GBP", rate: 48.10),
        Currency(code: "JPY", rate: 0.27),
        Currency(code: "CHF", rate: 43.00),
        Currency(code: "CAD", rate: 28.60),
        Currency(code: "AUD", rate: 25.70),
        Currency(code: "SEK", rate: 3.80),
        Currency(code: "PLN", rate: 9.50),
        Currency(code: "CZK", rate: 1.65)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(currencies) { currency in
                        HStack {
                            Text(currency.code)
                                .font(.title3)
                                .bold()
                            Spacer()
                            Text(String(format: "%.2f ₴", currency.rate))
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .onAppear {
                            if currency.id == currencies.last?.id {
                                loadMore()
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Currencies")
            .onAppear {
                loadMore()
            }
        }
    }
    
    private func loadMore() {
        let nextBatch = allCurrencies.dropFirst(loadedCount).prefix(3)
        currencies.append(contentsOf: nextBatch)
        loadedCount += nextBatch.count
    }
}

