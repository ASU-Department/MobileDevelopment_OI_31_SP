//
//  TeamsDirectory.swift
//  SportsHubDemo
//
//  Created by Maksym on 29.10.2025.
//

import SwiftUI

struct TeamsDirectoryView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    let allTeams: [Team]
    
    var body: some View {
        List(allTeams) { team in
            NavigationLink(team.city + " " + team.name, value: AppRoute.team(team))
        }
        .navigationTitle("Teams")
    }
}

#Preview {
    NavigationStack { TeamsDirectoryView(allTeams: SampleData.allTeams) }
}
