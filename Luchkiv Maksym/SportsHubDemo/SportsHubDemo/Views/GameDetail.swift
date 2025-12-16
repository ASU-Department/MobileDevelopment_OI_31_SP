//
//  GameDetail.swift
//  SportsHubDemo
//
//  Created by Maksym on 29.10.2025.
//

import SwiftUI

struct GameDetailView: View {
    @ObservedObject var viewModel: GameDetailViewModel
    
    var body: some View {
        List {
            Section("Matchup") {
                HStack {
                    teamBadge(team: viewModel.game.away, isFavorite: viewModel.isFavoriteAway)
                    Spacer()
                    Image(systemName: "at")
                        .imageScale(.large)
                        .accessibilityHidden(true)
                    Spacer()
                    teamBadge(team: viewModel.game.home, isFavorite: viewModel.isFavoriteHome)
                }
                .accessibilityElement(children: .combine)
                
                HStack {
                    Text("Score").foregroundStyle(.secondary)
                    Spacer()
                    Text("\(viewModel.game.awayScore) - \(viewModel.game.homeScore)")
                        .font(.title3)
                        .fontWeight(viewModel.game.isLive ? .bold : .regular)
                        .accessibilityLabel("Score \(viewModel.game.awayScore) to \(viewModel.game.homeScore)")
                }
                
                HStack {
                    Text("Status").foregroundStyle(.secondary)
                    Spacer()
                    Text(viewModel.game.statusText)
                        .foregroundStyle(viewModel.game.isLive ? .green : .secondary)
                        .accessibilityLabel(viewModel.game.isLive ? "Live" : "Final")
                }
            }
            
            Section("Predict") {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Home margin: \(Int(viewModel.predictedHomeMargin))")
                        .font(.headline)
                    
                    UISliderRepresentable(
                        value: $viewModel.predictedHomeMargin,
                        range: -20...20,
                        step: 1
                    )
                    
                    Text("Negative = away edge; positive = home edge.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            
            Section {
                Button {
                    viewModel.showShareSheet = true
                } label: {
                    Label("Share Summary", systemImage: "square.and.arrow.up")
                }
                .accessibilityIdentifier("shareButton")
            }
        }
        .navigationTitle("\(viewModel.game.away.short) @ \(viewModel.game.home.short)")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.showShareSheet) {
            ActivityViewControllerRepresentable(
                activityItems: [viewModel.shareText],
                applicationActivities: nil
            )
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
            viewModel: GameDetailViewModel(
                game: SampleData.games[0],
                isFavoriteHome: true,
                isFavoriteAway: true
            )
        )
    }
}
