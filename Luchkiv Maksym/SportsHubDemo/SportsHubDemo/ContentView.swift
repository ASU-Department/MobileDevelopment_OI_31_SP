//
//  ContentView.swift
//  SportsHubDemo
//
//  Created by Maksym on 19.10.2025.
//

import SwiftUI

struct Game {
    var team1: String
    var team2: String
    var score1: Int
    var score2: Int
    var isLive: Bool
}

struct ContentView: View {
    
    let games = [
        Game(team1: "Lakers", team2: "Warriors", score1: 102, score2: 98, isLive: true),
        Game(team1: "Nets", team2: "Celtics", score1: 102, score2: 98, isLive: false)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Text("SportsHub - Basketball Live Scores")
                    .font(.title)
                    .padding(.top, 20)
                
                VStack(alignment: .leading) {
                    Text("Live Scores")
                        .font(.headline)
                    List(games, id: \.team1) { game in
                        HStack {
                            Text("\(game.team1) vs \(game.team2)")
                            Spacer()
                            Text("\(game.score1) - \(game.score2)")
                                .fontWeight(game.isLive ? .bold : .regular)
                                .foregroundColor(game.isLive ? .green : .black)
                        }
                        
                    }
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Recent Results")
                        .font(.headline)
                    List(games, id: \.team1) { game in
                        HStack {
                            Text("\(game.team1) vs \(game.team2)")
                            Spacer()
                            Text("\(game.score1) - \(game.score2)")
                        }
                    }
                }
                .padding()
                
                VStack(alignment: .leading) {
                    Text("Player & Team Stats")
                        .font(.headline)
                    Text("Stats will be shown here...")
                        .foregroundColor(.gray)
                }
                .padding()
            }
            .navigationTitle("SportsHub")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    ContentView()
}
