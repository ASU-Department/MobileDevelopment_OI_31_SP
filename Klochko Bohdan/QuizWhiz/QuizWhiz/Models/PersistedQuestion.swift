//
//  PersistedQuestion.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import Foundation
import SwiftData

@Model
final class PersistedQuestion {
    var id: UUID
    var category: String
    var type: String
    var difficulty: String
    var question: String
    var correctAnswer: String
    var incorrectAnswers: [String]
    var isFavorite: Bool
    var userNote: String?
    var createdAt: Date
    
    init(
        id: UUID = UUID(),
        category: String,
        type: String,
        difficulty: String,
        question: String,
        correctAnswer: String,
        incorrectAnswers: [String],
        isFavorite: Bool = false,
        userNote: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.category = category
        self.type = type
        self.difficulty = difficulty
        self.question = question
        self.correctAnswer = correctAnswer
        self.incorrectAnswers = incorrectAnswers
        self.isFavorite = isFavorite
        self.userNote = userNote
        self.createdAt = createdAt
    }
    
    convenience init(from question: Question) {
        self.init(
            id: question.id,
            category: question.category,
            type: question.type,
            difficulty: question.difficulty,
            question: question.question,
            correctAnswer: question.correctAnswer,
            incorrectAnswers: question.incorrectAnswers,
            isFavorite: question.isFavorite,
            userNote: question.userNote
        )
    }
    
    func toQuestion() -> Question {
        Question(
            id: id,
            category: category,
            type: type,
            difficulty: difficulty,
            question: question,
            correctAnswer: correctAnswer,
            incorrectAnswers: incorrectAnswers,
            isFavorite: isFavorite,
            userNote: userNote
        )
    }
}

