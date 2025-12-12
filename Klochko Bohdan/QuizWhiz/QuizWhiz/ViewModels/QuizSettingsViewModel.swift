//
//  QuizSettingsViewModel.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class QuizSettingsViewModel: ObservableObject {
    @Published var questionCount: Int = UserPreferences.questionsPerPage
    @Published var selectedCategory: Category = categories.first!
    @Published var isHardMode: Bool = false
    
    var lastUpdateText: String {
        if let timestamp = UserPreferences.lastUpdateTimestamp {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            return "Last updated: \(formatter.localizedString(for: timestamp, relativeTo: Date()))"
        }
        return "No updates yet"
    }
    
    func updateQuestionCount(_ count: Int) {
        questionCount = count
        UserPreferences.questionsPerPage = count
    }
}


