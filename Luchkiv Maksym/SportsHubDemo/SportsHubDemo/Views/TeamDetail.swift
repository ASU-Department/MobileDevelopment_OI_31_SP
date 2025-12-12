//
//  TeamDetail.swift
//  SportsHubDemo
//
//  Created by Maksym on 29.10.2025.
//

import SwiftUI

struct TeamDetailView: View {
    @ObservedObject var viewModel: TeamDetailViewModel
    
    var body: some View {
        List {
            Section("\(viewModel.team.city) \(viewModel.team.name)") {
                HStack {
                    Text(viewModel.team.short)
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Text("Stats")
                        .font(.headline)
                }
            }
            
            Section("Scope") {
                SegmentedControlRepresentable(
                    selectedIndex: $viewModel.selectedScopeIndex,
                    segments: viewModel.scopes.map {
                        $0.rawValue
                    }
                )
                .frame(height: 32)
                .accessibilityIdentifier("statsScopeControl")
            }
            
            Section("Players") {
                ForEach(viewModel.playerStats) { line in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(line.player.name).font(.body)
                            Text("\(line.season) - GP \(line.gp)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        HStack(spacing: 12) {
                            statPill("PTS", line.pts)
                            statPill("REB", line.reb)
                            statPill("AST", line.ast)
                        }
                        .accessibilityElement(children: .combine)
                    }
                    .padding(.vertical, 2)
                }
            }
            
            Section {
                Button {
                    viewModel.showBoxScore = true
                } label: {
                    Label("Open Latest Box Score", systemImage: "doc.text.magnifyingglass")
                }
            }
        }
        .sheet(isPresented: $viewModel.showBoxScore) {
            SafariViewRepresentable(url: URL(string: "https://www.nba.com/stats/")!)
        }
        .navigationTitle(viewModel.team.short)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func statPill(_ title: String, _ value: Double) -> some View {
        VStack(spacing: 2) {
            Text(title).font(.caption2).foregroundStyle(.secondary)
            Text(String(format: "%.1f", value)).font(.callout).bold()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(AppColor.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    NavigationStack { TeamDetailView(viewModel: TeamDetailViewModel(team: SampleData.warriors)) }
}
