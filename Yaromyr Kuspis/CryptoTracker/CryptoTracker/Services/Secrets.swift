//
//  Secrets.swift
//  CryptoTracker
//
//  Created by Яромир-Олег Куспісь on 03.11.2025.
//

import Foundation

// Provides safe, typed access to secrets defined in Info.plist.
enum Secrets {
    // An internal enum to prevent typos when accessing Info.plist keys.
    private enum Keys: String {
        case coinGeckoAPIKey = "COINGECKO_API_KEY"
    }

    private static func infoForKey(_ key: Keys) -> String {
        guard let info = Bundle.main.infoDictionary,
              let value = info[key.rawValue] as? String
        else {
            // This error indicates a project configuration issue.
            fatalError("Could not find \(key.rawValue) in Info.plist. Check your configuration.")
        }
        return value
    }

    static var coinGeckoApiKey: String {
        return infoForKey(.coinGeckoAPIKey)
    }
}
