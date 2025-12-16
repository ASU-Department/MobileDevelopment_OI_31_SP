//
//  QuoteCacheActor.swift
//  habitBuddy
//
//  Created by  User on 14.12.2025.
//

import Foundation

actor QuoteCacheActor {

    private let key = "cachedQuote"

    func save(_ quote: String) {
        UserDefaults.standard.set(quote, forKey: key)
    }

    func load() -> String? {
        UserDefaults.standard.string(forKey: key)
    }
}
