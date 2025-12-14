//
//  QuizView.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import SwiftUI
import SwiftData

struct QuizView: View {
    let category: Category
    let questionCount: Int
    let isHardMode: Bool
    
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: QuizViewModel
    
    @State private var selectedAnswer: String?
    @State private var showResult = false
    @State private var currentQuestionIndex = 0
    @State private var score = 0
    @State private var editingQuestion: Question?
    @State private var showCompletion = false
    @Environment(\.dismiss) private var dismiss
    
    init(category: Category, questionCount: Int, isHardMode: Bool) {
        self.category = category
        self.questionCount = questionCount
        self.isHardMode = isHardMode
        _viewModel = StateObject(wrappedValue: QuizViewModel(
            category: category.name,
            questionCount: questionCount,
            isHardMode: isHardMode
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if viewModel.isLoading {
                    loadingView
                } else if let error = viewModel.error {
                    errorView(error)
                } else if viewModel.questions.isEmpty {
                    emptyStateView
                } else {
                    quizContentView
                }
            }
            .padding()
        }
        .navigationTitle("Quiz")
        .navigationBarTitleDisplayMode(.inline)
        .refreshable {
            await viewModel.refresh(modelContext: modelContext)
        }
        .onAppear {
            Task {
                await viewModel.loadQuestions(modelContext: modelContext)
            }
        }
        .sheet(item: $editingQuestion) { question in
            NoteEditorView(question: question) { updatedQuestion in
                viewModel.updateQuestion(updatedQuestion, in: modelContext)
            }
        }
        .fullScreenCover(isPresented: $showCompletion) {
            NavigationStack {
                QuizCompletionView(
                    score: score,
                    totalQuestions: viewModel.questions.count,
                    category: category.name
                )
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            showCompletion = false
                            dismiss()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading questions...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 300)
    }
    
    // MARK: - Error View
    private func errorView(_ error: Error) -> some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Error loading questions")
                .font(.title2.bold())
            
            Text(error.localizedDescription)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            if !viewModel.offlineQuestions.isEmpty {
                VStack(spacing: 12) {
                    Text("Showing offline questions")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Button("Use Offline Questions") {
                        viewModel.useOfflineQuestions()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.top)
            }
            
            Button("Retry") {
                Task {
                    await viewModel.loadQuestions(modelContext: modelContext)
                }
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Empty State View
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No questions available")
                .font(.title2.bold())
            
            Text("Try refreshing or check your connection")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button("Refresh") {
                Task {
                    await viewModel.refresh(modelContext: modelContext)
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Quiz Content View
    private var quizContentView: some View {
        VStack(spacing: 20) {
            // Progress indicator
            progressView
            
            // Current question
            if currentQuestionIndex < viewModel.questions.count {
                questionCard(viewModel.questions[currentQuestionIndex])
            }
            
            // Navigation buttons
            if showResult {
                resultView
            } else {
                answerButtons
            }
        }
    }
    
    // MARK: - Progress View
    private var progressView: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Question \(currentQuestionIndex + 1) of \(viewModel.questions.count)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                Text("Score: \(score)")
                    .font(.subheadline.bold())
                    .foregroundColor(.blue)
            }
            
            ProgressView(value: Double(currentQuestionIndex), total: Double(viewModel.questions.count))
                .tint(.blue)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    // MARK: - Question Card
    private func questionCard(_ question: Question) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(question.category)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: difficultyIcon(question.difficulty))
                            .font(.caption)
                        Text(question.difficulty.capitalized)
                            .font(.caption.bold())
                    }
                    .foregroundColor(difficultyColor(question.difficulty))
                }
                
                Spacer()
                
                Button(action: {
                    editingQuestion = question
                }) {
                    Image(systemName: question.userNote != nil ? "note.text" : "note.text.badge.plus")
                        .foregroundColor(.blue)
                }
                
                Button(action: {
                    viewModel.toggleFavorite(question, in: modelContext)
                }) {
                    Image(systemName: question.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(question.isFavorite ? .red : .gray)
                }
            }
            
            Divider()
            
            Text(question.question)
                .font(.title3.bold())
                .fixedSize(horizontal: false, vertical: true)
            
            if let note = question.userNote, !note.isEmpty {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "note.text")
                        .foregroundColor(.blue)
                        .font(.caption)
                    Text(note)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
    }
    
    // MARK: - Answer Buttons
    private var answerButtons: some View {
        VStack(spacing: 12) {
            if let question = viewModel.questions[safe: currentQuestionIndex] {
                ForEach(question.allAnswers, id: \.self) { answer in
                    Button(action: {
                        selectedAnswer = answer
                        showResult = true
                        if answer == question.correctAnswer {
                            score += 1
                        }
                    }) {
                        HStack {
                            Text(answer)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        .padding()
                        .background(
                            selectedAnswer == answer
                            ? Color.blue.opacity(0.2)
                            : Color(.systemGray6)
                        )
                        .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                    .disabled(selectedAnswer != nil)
                }
            }
        }
    }
    
    // MARK: - Result View
    private var resultView: some View {
        VStack(spacing: 16) {
            if let question = viewModel.questions[safe: currentQuestionIndex] {
                let isCorrect = selectedAnswer == question.correctAnswer
                
                HStack(spacing: 12) {
                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(isCorrect ? .green : .red)
                    
                    Text(isCorrect ? "Correct!" : "Incorrect")
                        .font(.title2.bold())
                        .foregroundColor(isCorrect ? .green : .red)
                }
                
                if !isCorrect {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Correct answer:")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(question.correctAnswer)
                            .font(.body.bold())
                            .foregroundColor(.green)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.green.opacity(0.1))
                    .cornerRadius(12)
                }
            }
            
            HStack(spacing: 16) {
                if currentQuestionIndex < viewModel.questions.count - 1 {
                    Button("Next Question") {
                        nextQuestion()
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                } else {
                    Button("Finish Quiz") {
                        finishQuiz()
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    // MARK: - Helper Methods
    private func difficultyIcon(_ difficulty: String) -> String {
        switch difficulty.lowercased() {
        case "easy": return "circle.fill"
        case "medium": return "circle.lefthalf.filled"
        case "hard": return "circle"
        default: return "circle"
        }
    }
    
    private func difficultyColor(_ difficulty: String) -> Color {
        switch difficulty.lowercased() {
        case "easy": return .green
        case "medium": return .orange
        case "hard": return .red
        default: return .gray
        }
    }
    
    private func nextQuestion() {
        currentQuestionIndex += 1
        selectedAnswer = nil
        showResult = false
    }
    
    private func finishQuiz() {
        showCompletion = true
    }
}

// MARK: - Array Safe Subscript Extension
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

