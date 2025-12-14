//
//  UserPreferences.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import Foundation

class UserPreferences {
    private static let defaults = UserDefaults.standard
    
    // Keys
    private enum Keys {
        static let lastUpdateTimestamp = "lastUpdateTimestamp"
        static let selectedFilter = "selectedFilter"
        static let autoRefreshEnabled = "autoRefreshEnabled"
        static let questionsPerPage = "questionsPerPage"
        static let favoriteQuestionIds = "favoriteQuestionIds"
    }
    
    // Last update timestamp
    static var lastUpdateTimestamp: Date? {
        get {
            if let timestamp = defaults.object(forKey: Keys.lastUpdateTimestamp) as? Date {
                return timestamp
            }
            return nil
        }
        set {
            defaults.set(newValue, forKey: Keys.lastUpdateTimestamp)
        }
    }
    
    // Selected filter (difficulty or category)
    static var selectedFilter: String? {
        get {
            return defaults.string(forKey: Keys.selectedFilter)
        }
        set {
            defaults.set(newValue, forKey: Keys.selectedFilter)
        }
    }
    
    // Auto refresh enabled
    static var autoRefreshEnabled: Bool {
        get {
            return defaults.bool(forKey: Keys.autoRefreshEnabled)
        }
        set {
            defaults.set(newValue, forKey: Keys.autoRefreshEnabled)
        }
    }
    
    // Questions per page
    static var questionsPerPage: Int {
        get {
            let value = defaults.integer(forKey: Keys.questionsPerPage)
            return value > 0 ? value : 10
        }
        set {
            defaults.set(newValue, forKey: Keys.questionsPerPage)
        }
    }
    
    static var favoriteQuestionIds: [String] {
        get {
            return defaults.stringArray(forKey: Keys.favoriteQuestionIds) ?? []
        }
        set {
            defaults.set(newValue, forKey: Keys.favoriteQuestionIds)
        }
    }
    
    static func addFavorite(_ questionId: UUID) {
        var ids = favoriteQuestionIds
        let idString = questionId.uuidString
        if !ids.contains(idString) {
            ids.append(idString)
            favoriteQuestionIds = ids
        }
    }
    
    static func removeFavorite(_ questionId: UUID) {
        var ids = favoriteQuestionIds
        ids.removeAll { $0 == questionId.uuidString }
        favoriteQuestionIds = ids
    }
    
    static func isFavorite(_ questionId: UUID) -> Bool {
        return favoriteQuestionIds.contains(questionId.uuidString)
    }
}

