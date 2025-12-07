//
//  SettingsService.swift
//  space3
//
//  Created by Pab1m on 07.12.2025.
//

import Foundation

class SettingsService {
    
    private let textSizeKey = "textSizeKey"

    func saveTextSize(_ size: Double) {
        UserDefaults.standard.set(size, forKey: textSizeKey)
    }

    func loadTextSize() -> Double {
        let saved = UserDefaults.standard.double(forKey: textSizeKey)
        return saved == 0 ? 16 : saved
    }
}
