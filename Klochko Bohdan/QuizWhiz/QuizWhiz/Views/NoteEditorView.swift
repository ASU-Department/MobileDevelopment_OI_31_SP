//
//  NoteEditorView.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import SwiftUI
import SwiftData

struct NoteEditorView: View {
    let question: Question
    let coordinator: AppCoordinator
    let onSave: ((Question) -> Void)?
    
    @StateObject private var viewModel: NoteEditorViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(question: Question, coordinator: AppCoordinator, onSave: ((Question) -> Void)? = nil) {
        self.question = question
        self.coordinator = coordinator
        self.onSave = onSave
        _viewModel = StateObject(wrappedValue: NoteEditorViewModel(
            question: question,
            repository: coordinator.questionRepository
        ))
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
                    TextEditor(text: $viewModel.noteText)
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
                        Task {
                            do {
                                let updatedQuestion = try await viewModel.save()
                                onSave?(updatedQuestion)
                                dismiss()
                            } catch {
                                // Error is handled by viewModel.error
                            }
                        }
                    }
                }
            }
        }
    }
}

