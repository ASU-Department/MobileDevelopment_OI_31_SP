//
//  FavoritesView.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = FavoritesViewModel()
    
    @State private var selectedQuestion: Question?
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                loadingView
            } else if viewModel.favoriteQuestions.isEmpty {
                emptyStateView
            } else {
                questionsList
            }
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.loadFavorites(modelContext: modelContext)
        }
        .onAppear {
            Task {
                await viewModel.loadFavorites(modelContext: modelContext)
            }
        }
        .sheet(item: $selectedQuestion) { question in
            NoteEditorView(question: question) { updatedQuestion in
                viewModel.updateQuestion(updatedQuestion, in: modelContext)
            }
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Loading favorites...")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No Favorites Yet")
                .font(.title2.bold())
            
            Text("Mark questions as favorites during quizzes to see them here")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var questionsList: some View {
        List {
            ForEach(viewModel.favoriteQuestions) { question in
                QuestionRowView(question: question) {
                    viewModel.toggleFavorite(question, in: modelContext)
                } onEditNote: {
                    selectedQuestion = question
                }
            }
        }
        .listStyle(.insetGrouped)
        .refreshable {
            await viewModel.loadFavorites(modelContext: modelContext)
        }
    }
}

struct QuestionRowView: View {
    let question: Question
    let onToggleFavorite: () -> Void
    let onEditNote: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(question.category)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: difficultyIcon(question.difficulty))
                            .font(.caption2)
                        Text(question.difficulty.capitalized)
                            .font(.caption2.bold())
                    }
                    .foregroundColor(difficultyColor(question.difficulty))
                }
                
                Spacer()
                
                Button(action: onEditNote) {
                    Image(systemName: question.userNote != nil ? "note.text" : "note.text.badge.plus")
                        .foregroundColor(.blue)
                }
                
                Button(action: onToggleFavorite) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
            }
            
            Text(question.question)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
            
            if let note = question.userNote, !note.isEmpty {
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "note.text")
                        .foregroundColor(.blue)
                        .font(.caption2)
                    Text(note)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 4)
            }
        }
        .padding(.vertical, 4)
    }
    
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
}

