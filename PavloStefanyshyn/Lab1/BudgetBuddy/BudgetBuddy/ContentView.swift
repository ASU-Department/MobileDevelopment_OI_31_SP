//
//  ContentView.swift
//  BudgetBuddy
//
//  Created by Nill on 26.10.2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TabView {
            IndexView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            RequestsView()
                .tabItem {
                    Label("Analysis", systemImage: "chart.bar.xaxis")
                }
            
            CurrencyView()
                .tabItem {
                    Label("Currencies", systemImage: "dollarsign.circle.fill")
                }
        }
        .accentColor(.blue)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color(.systemGray6), for: .tabBar)
        .tabViewStyle(.automatic)
    }
}

#Preview {
    ContentView()
}
