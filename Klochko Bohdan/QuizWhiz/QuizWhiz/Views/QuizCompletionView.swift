//
//  QuizCompletionView.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import SwiftUI

struct QuizCompletionView: View {
    let score: Int
    let totalQuestions: Int
    let category: String
    @Environment(\.dismiss) private var dismiss
    @State private var showShare = false
    
    private var percentage: Double {
        Double(score) / Double(totalQuestions) * 100
    }
    
    private var performanceMessage: String {
        switch percentage {
        case 90...100:
            return "Outstanding! 🎉"
        case 70..<90:
            return "Great job! 👍"
        case 50..<70:
            return "Good effort! 💪"
        default:
            return "Keep practicing! 📚"
        }
    }
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Score Circle
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 12)
                    .frame(width: 150, height: 150)
                
                Circle()
                    .trim(from: 0, to: percentage / 100)
                    .stroke(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1.0), value: percentage)
                
                VStack(spacing: 4) {
                    Text("\(score)")
                        .font(.system(size: 48, weight: .bold))
                    Text("of \(totalQuestions)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            // Performance Message
            Text(performanceMessage)
                .font(.title.bold())
            
            Text("\(Int(percentage))% Correct")
                .font(.title3)
                .foregroundColor(.secondary)
            
            Text("Category: \(category)")
                .font(.body)
                .foregroundColor(.secondary)
            
            Spacer()
            
            // Action Buttons
            VStack(spacing: 16) {
                Button(action: {
                    showShare = true
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share Result")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .buttonStyle(.borderedProminent)
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Back to Settings")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal)
        }
        .padding()
        .sheet(isPresented: $showShare) {
            ShareSheetController(
                activityItems: [
                    "I scored \(score)/\(totalQuestions) (\(Int(percentage))%) in \(category) quiz! 🎯"
                ]
            )
        }
    }
}


