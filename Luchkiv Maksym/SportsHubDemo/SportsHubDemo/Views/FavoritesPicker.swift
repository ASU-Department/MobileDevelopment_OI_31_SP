//
//  FavoritesPicker.swift
//  SportsHubDemo
//
//  Created by Maksym on 19.10.2025.
//
import SwiftUI

struct FavoritesPicker: View {
    @Binding var favoriteTeams: Set<Team>
    let allTeams: [Team]
    
    var body: some View {
        List {
            Section("Tap to (un)select favorites") {
                ForEach(allTeams) { team in
                    HStack {
                        Text("\(team.city) \(team.name)")
                        Spacer()
                        
                        if favoriteTeams.contains(team) {
                            Image(systemName: "star.fill")
                                .imageScale(.small)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if favoriteTeams.contains(team) {
                            favoriteTeams.remove(team)
                        } else {
                            favoriteTeams.insert(team)
                        }
                    }
                }
            }
        }
        .navigationTitle("Favorite Teams")
    }
}

#Preview {
    NavigationStack {
        FavoritesPicker(
            favoriteTeams: .constant([SampleData.lakers]),
            allTeams: SampleData.allTeams
        )
    }
}

