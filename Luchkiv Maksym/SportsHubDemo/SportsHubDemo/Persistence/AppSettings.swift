//
//  AppSettings.swift
//  SportsHubDemo
//
//  Created by Maksym on 18.11.2025.
//

import Foundation

final class AppSettingsStore {
    static let shared = AppSettingsStore()
    
    private let defaults: UserDefaults
    
    private enum Keys {
        static let showLiveOnly = "filter.showLiveOnly"
        static let query = "filter.query"
        static let lastUpdateDate = "lastUpdateDate"
    }
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    var showLiveOnly: Bool {
        get {
            defaults.object(forKey: Keys.showLiveOnly) as? Bool ?? true
        }
        set {
            defaults.set(newValue, forKey: Keys.showLiveOnly)
        }
    }
    
    var query: String {
        get {
            defaults.string(forKey: Keys.query) ?? ""
        }
        set {
            defaults.set(newValue, forKey: Keys.query)
        }
    }
    
    var lastUpdateDate: Date? {
        get {
            defaults.object(forKey: Keys.lastUpdateDate) as? Date
        }
        set {
            defaults.set(newValue, forKey: Keys.lastUpdateDate)
        }
    }
}
