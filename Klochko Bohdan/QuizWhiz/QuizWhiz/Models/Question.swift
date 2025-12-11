//
//  Question.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import Foundation
import UIKit

// MARK: - API Response Models
struct APIResponse: Codable {
    let responseCode: Int
    let results: [APIQuestion]
    
    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case results
    }
}

struct APIQuestion: Codable {
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    enum CodingKeys: String, CodingKey {
        case category, type, difficulty, question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}

// MARK: - App Model
struct Question: Identifiable, Codable, Hashable {
    let id: UUID
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    var isFavorite: Bool
    var userNote: String?
    
    nonisolated init(id: UUID = UUID(), category: String, type: String, difficulty: String, question: String, correctAnswer: String, incorrectAnswers: [String], isFavorite: Bool = false, userNote: String? = nil) {
        self.id = id
        self.category = category
        self.type = type
        self.difficulty = difficulty
        self.question = question
        self.correctAnswer = correctAnswer
        self.incorrectAnswers = incorrectAnswers
        self.isFavorite = isFavorite
        self.userNote = userNote
    }
    
    nonisolated init(from apiQuestion: APIQuestion) {
        self.id = UUID()
        self.category = apiQuestion.category
        self.type = apiQuestion.type
        self.difficulty = apiQuestion.difficulty
        self.question = apiQuestion.question.decodedHTML
        self.correctAnswer = apiQuestion.correctAnswer.decodedHTML
        self.incorrectAnswers = apiQuestion.incorrectAnswers.map { $0.decodedHTML }
        self.isFavorite = false
        self.userNote = nil
    }
    
    var allAnswers: [String] {
        var answers = incorrectAnswers
        answers.append(correctAnswer)
        return answers.shuffled()
    }
}

// MARK: - HTML Decoding Extension
extension String {
    var decodedHTML: String {
        guard let data = self.data(using: .utf8) else { return self }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(
            data: data,
            options: options,
            documentAttributes: nil
        ) else {
            return self
        }
        
        return attributedString.string
    }
}



