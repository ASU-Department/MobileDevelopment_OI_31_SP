//
//  NoteEditorView.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import SwiftUI

struct NoteEditorView: View {
    let question: Question
    let onSave: (Question) -> Void
    
    @State private var noteText: String
    @Environment(\.dismiss) private var dismiss
    
    init(question: Question, onSave: @escaping (Question) -> Void) {
        self.question = question
        self.onSave = onSave
        _noteText = State(initialValue: question.userNote ?? "")
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text(question.question)
                        .font(.body)
                        .padding(.vertical, 4)
                } header: {
                    Text("Question")
                }
                
                Section {
                    TextEditor(text: $noteText)
                        .frame(minHeight: 150)
                } header: {
                    Text("Your Note")
                } footer: {
                    Text("Add a personal note or reminder about this question")
                }
            }
            .navigationTitle("Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        var updatedQuestion = question
                        updatedQuestion.userNote = noteText.isEmpty ? nil : noteText
                        onSave(updatedQuestion)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NoteEditorView(
        question: Question(
            category: "Science",
            type: "multiple",
            difficulty: "medium",
            question: "What is the chemical symbol for water?",
            correctAnswer: "H2O",
            incorrectAnswers: ["CO2", "NaCl", "O2"],
            isFavorite: false,
            userNote: nil
        )
    ) { updatedQuestion in
        print("Note saved: \(updatedQuestion.userNote ?? "nil")")
    }
}

