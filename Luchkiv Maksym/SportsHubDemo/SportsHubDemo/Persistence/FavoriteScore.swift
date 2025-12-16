//
//  FavoriteScore.swift
//  SportsHubDemo
//
//  Created by Maksym on 29.10.2025.
//

import Foundation

final class FavoriteStore {
    private let key: String
    private let defaults: UserDefaults
    static let shared = FavoriteStore()

    init(defaults: UserDefaults = .standard, key: String = "favoriteTeams.v1") {
        self.defaults = defaults
        self.key = key
    }

    func save(_ teams: Set<Team>) {
        do {
            let data = try JSONEncoder().encode(Array(teams))
            defaults.set(data, forKey: key)
        } catch {
            print("Failed to save favorites: \(error)")
        }
    }

    func load() -> Set<Team> {
        guard let data = defaults.data(forKey: key),
              let arr = try? JSONDecoder().decode([Team].self, from: data) else {
            return []
        }
        return Set(arr)
    }
}
