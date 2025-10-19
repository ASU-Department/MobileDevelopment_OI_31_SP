//
//  GameRow.swift
//  SportsHubDemo
//
//  Created by Maksym on 19.10.2025.
//
import SwiftUI

struct GameRow: View {
    let game: Gamee
    let highlight: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading) {
                Text("\(game.away.city) \(game.away.name) @ \(game.home.city) \(game.home.name)")
                    .font(.subheadline)
                    .lineLimit(1)
                Text(game.statusText)
                    .font(.caption)
                    .foregroundStyle(game.isLive ? .green : .secondary)
            }
            Spacer()
            Text("\(game.awayScore) - \(game.homeScore)")
                .fontWeight(game.isLive ? .bold : .regular)
        }
        .padding(.vertical, 6)
        .background(highlight ? .yellow.opacity(0.15) : .clear)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    GameRow(game: SampleData.games[0], highlight: true)
        .padding()
}
