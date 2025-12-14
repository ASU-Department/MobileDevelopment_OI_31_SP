//
//  QuizStartView.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import SwiftUI

struct QuizStartView: View {
    var category: Category
    var questionCount: Int
    var isHardMode: Bool
    
    @State private var difficulty: Double = 0.5
    @State private var showShare = false

    var body: some View {
        VStack(spacing: 24) {

            Text("Quiz Started")
                .font(.largeTitle.bold())

            Text("Category: \(category.name)")
                .font(.title3)

            // UIKit Slider
            SliderView(value: $difficulty)
                .frame(height: 40)
                .padding()

            Button("Share Result") {
                showShare = true
            }
            .buttonStyle(.borderedProminent)
            .sheet(isPresented: $showShare) {
                ShareSheetController(activityItems: ["I started the quiz in \(category.name)!"])
            }

            Spacer()
        }
        .padding()
    }
}
