//
//  TeamsDirectory.swift
//  SportsHubDemo
//
//  Created by Maksym on 29.10.2025.
//

import SwiftUI

struct TeamsDirectoryView: View {
    let allTeams: [Team]
    
    var body: some View {
        List(allTeams) { team in
            NavigationLink(team.city + " " + team.name) {
                TeamDetailView(viewModel: TeamDetailViewModel(team: team))
            }
        }
        .navigationTitle("Teams")
    }
}

#Preview {
    NavigationStack { TeamsDirectoryView(allTeams: SampleData.allTeams) }
}
