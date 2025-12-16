//
//  SettingsViewModel.swift
//  WeatherWise
//
//  Created by vburdyk on 15.12.2025.
//

import Foundation
import Combine

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var use24HourFormat: Bool = true
    @Published var locationName: String = "Львів"
    @Published var notificationsEnabled: Bool = false
}
