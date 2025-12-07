//
//  MainView.swift
//  space3
//
//  Created by Pab1m on 29.11.2025.
//


import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Tab("Home", systemImage: "cloud.sun") {
                HomeView()
            }
            .badge(1)

            Tab("Explore", systemImage: "airplane") {
                ExploreView()
            }
        }
    }
}

#Preview {
    MainView()
}
