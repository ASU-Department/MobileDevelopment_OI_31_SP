//
//  FavoriteScore.swift
//  SportsHubDemo
//
//  Created by Maksym on 29.10.2025.
//

import Foundation

final class FavoriteStore {
    private let key = "favoriteTeams.v1"
    static let shared = FavoriteStore()
    
    func save(_ teams: Set<Team>) {
        do {
            let data = try JSONEncoder().encode(Array(teams))
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Failed to save favorites: \(error)")
        }
    }
    
    func load() -> Set<Team> {
        guard let data = UserDefaults.standard.data(forKey: key),
              let arr = try? JSONDecoder().decode([Team].self, from: data) else {
            return []
        }
        return Set(arr)
    }
}
