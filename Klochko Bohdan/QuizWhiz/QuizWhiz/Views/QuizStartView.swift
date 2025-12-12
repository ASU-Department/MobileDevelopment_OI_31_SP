//
//  QuizStartView.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import SwiftUI

struct QuizStartView: View {
    let category: Category
    let questionCount: Int
    let isHardMode: Bool
    let coordinator: AppCoordinator
    
    var body: some View {
        QuizView(
            category: category,
            questionCount: questionCount,
            isHardMode: isHardMode,
            coordinator: coordinator
        )
    }
}
