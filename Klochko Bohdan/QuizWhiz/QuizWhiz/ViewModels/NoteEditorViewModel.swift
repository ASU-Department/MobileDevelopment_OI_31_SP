//
//  NoteEditorViewModel.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class NoteEditorViewModel: ObservableObject {
    @Published var noteText: String
    @Published var error: Error?
    
    private let question: Question
    private let repository: QuestionRepositoryProtocol
    
    init(question: Question, repository: QuestionRepositoryProtocol) {
        self.question = question
        self.repository = repository
        self.noteText = question.userNote ?? ""
    }
    
    func save() async throws -> Question {
        var updatedQuestion = question
        updatedQuestion.userNote = noteText.isEmpty ? nil : noteText
        
        try await repository.updateQuestion(updatedQuestion)
        return updatedQuestion
    }
}

