import Foundation
import SwiftData
@testable import SportsHubDemo

enum TestHelpers {
    static func makeInMemoryContainer() throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: GameRecord.self, configurations: config)
    }

    static func makeBDLGame(
        id: Int = 1,
        status: String = "Final",
        home: (short: String, city: String, name: String) = ("LAL", "Los Angeles", "Lakers"),
        away: (short: String, city: String, name: String) = ("GSW", "Golden State", "Warriors"),
        homeScore: Int = 100,
        awayScore: Int = 98,
        season: Int = 2024
    ) -> BDLGame {
        let homeTeam = BDLTeam(
            id: id * 10,
            abbreviation: home.short,
            city: home.city,
            conference: "West",
            division: "Pacific",
            full_name: "\(home.city) \(home.name)",
            name: home.name
        )

        let awayTeam = BDLTeam(
            id: id * 10 + 1,
            abbreviation: away.short,
            city: away.city,
            conference: "West",
            division: "Pacific",
            full_name: "\(away.city) \(away.name)",
            name: away.name
        )

        return BDLGame(
            id: id,
            date: "2024-01-01",
            home_team: homeTeam,
            home_team_score: homeScore,
            visitor_team: awayTeam,
            visitor_team_score: awayScore,
            period: 4,
            status: status,
            time: "",
            season: season,
            postseason: false
        )
    }
}
