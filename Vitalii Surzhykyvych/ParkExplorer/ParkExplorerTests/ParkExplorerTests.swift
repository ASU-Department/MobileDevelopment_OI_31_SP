//
//  ParkExplorerTests.swift
//  ParkExplorer
//
//  Created by Vitalik on 19.12.2025.
//

import Testing
@testable import ParkExplorer

struct FavoriteLogicTests {

    @Test
    func toggleFavoriteAddsId() {
        var favorites: Set<String> = []
        favorites.insert("1")

        #expect(favorites.contains("1"))
    }
}
