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
    
    var body: some View {
        QuizView(
            category: category,
            questionCount: questionCount,
            isHardMode: isHardMode
        )
    }
}
