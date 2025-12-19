//
//  UserSettings.swift
//  Lab5_ParkExplorer
//
//  Created by Vitalik on 18.12.2025.
//

import UIKit

struct UserSettings {
    static var lastUpdate: Date? {
        get { UserDefaults.standard.object(forKey: "lastUpdate") as? Date }
        set { UserDefaults.standard.set(newValue, forKey: "lastUpdate") }
    }
}
