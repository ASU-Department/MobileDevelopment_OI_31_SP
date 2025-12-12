//
//  StartButton.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import SwiftUI

struct StartButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Start Quiz")
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(radius: 5)
        }
    }
}
