//
//  GameDetail.swift
//  SportsHubDemo
//
//  Created by Maksym on 29.10.2025.
//

import SwiftUI

struct GameDetailView: View {
    let game: Game
    let isFavoriteHome: Bool
    let isFavoriteAway: Bool
    
    @State private var predictedHomeMargin: Double = 0
    @State private var showShareSheet = false
    
    private var shareText: String {
        let line = "\(game.away.city) \(game.away.name) @ \(game.home.city) \(game.home.name)"
        let score = "\(game.awayScore) - \(game.homeScore) (\(game.statusText))"
        let prediction = String(format: "Predicted margin (home): %.0f", predictedHomeMargin)
        return "SportsHub:\n\(line)\n\(score)\n\(prediction)"
    }
    
    var body: some View {
        List {
            Section("Matchup") {
                HStack {
                    teamBadge(team: game.away, isFavorite: isFavoriteAway)
                    Spacer()
                    Image(systemName: "at")
                        .imageScale(.large)
                        .accessibilityHidden(true)
                    Spacer()
                    teamBadge(team: game.home, isFavorite: isFavoriteHome)
                }
                .accessibilityElement(children: .combine)
                
                HStack {
                    Text("Score").foregroundStyle(.secondary)
                    Spacer()
                    Text("\(game.awayScore) - \(game.homeScore)")
                        .font(.title3).bold(game.isLive)
                        .accessibilityLabel("Score \(game.awayScore) to \(game.homeScore)")
                }
                
                HStack {
                    Text("Status").foregroundStyle(.secondary)
                    Spacer()
                    Text(game.statusText)
                        .foregroundStyle(game.isLive ? .green : .secondary)
                        .accessibilityLabel(game.isLive ? "Live" : "Final")
                }
            }
            
            Section("Predict") {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Home margin: \(Int(predictedHomeMargin))")
                        .font(.headline)
                    
                    // TODO: Implement UIKit slider here
                    
                    Text("Negative = away edge; positive = home edge.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            
            Section {
                Button {
                    showShareSheet = true
                } label: {
                    Label("Share Summary", systemImage: "square.and.arrow.up")
                }
                .accessibilityIdentifier("shareButton")
            }
        }
        .navigationTitle("\(game.away.short) @ \(game.home.short)")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showShareSheet) {
            // TODO: add ActivityViewControllerRepresentable here
        }
    }
    
    @ViewBuilder
    private func teamBadge(team: Team, isFavorite: Bool) -> some View {
        VStack(spacing: 6) {
            Text(team.short)
                .font(.largeTitle).bold()
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isFavorite ? AppColor.favorite.opacity(0.35) : AppColor.secondary)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Text("\(team.city) \(team.name)")
                .font(.callout)
        }
        .accessibilityLabel("\(team.city) \(team.name)\(isFavorite ? " favorite" : "")")
    }
}

#Preview {
    NavigationStack {
        GameDetailView(
            game: SampleData.games[0],
            isFavoriteHome: true,
            isFavoriteAway: true
        )
    }
}
