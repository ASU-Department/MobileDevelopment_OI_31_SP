//
//  TeamDetail.swift
//  SportsHubDemo
//
//  Created by Maksym on 29.10.2025.
//

import SwiftUI

struct TeamDetailView: View {
    let team: Team
    @State private var selectedScopeIndex = 1
    private var scopes: [StatScope] {StatScope.allCases}
    private var currentScope: StatScope { scopes[selectedScopeIndex]}
    
    @State private var showBoxScore = false
    
    var body: some View {
        List {
            Section("\(team.city) \(team.name)") {
                HStack {
                    Text(team.short)
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Text("Stats")
                        .font(.headline)
                }
            }
            
            Section("Scope") {
                SegmentedControlRepresentable(
                    selectedIndex: $selectedScopeIndex,
                    segments: scopes.map {
                        $0.rawValue
                    }
                )
                .frame(height: 32)
                .accessibilityIdentifier("statsScopeControl")
            }
            
            Section("Players") {
                ForEach(SampleData.statsForTeam(short: team.short, scope: currentScope)) { line in
                    
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
                    showBoxScore = true
                } label: {
                    Label("Open Latest Box Score", systemImage: "doc.text.magnifyingglass")
                }
            }
        }
        .sheet(isPresented: $showBoxScore) {
            SafariViewRepresentable(url: URL(string: "https://www.nba.com/stats/")!)
        }
        .navigationTitle(team.short)
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
    NavigationStack { TeamDetailView(team: SampleData.warriors) }
}
