//
//  ContentView.swift
//  BudgetBuddy
//
//  Created by Nill on 14.12.2025.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var coordinator: AppCoordinators
    @Environment(\.modelContext) private var context

    var body: some View {
        TabView {

            coordinator.makeIndexView(context: context)
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
    }
}
