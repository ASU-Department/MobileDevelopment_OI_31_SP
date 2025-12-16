//
//  SettingsViewModel.swift
//  Lab2_TimeCapsule
//
//  Created by User on 10.12.2025.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @AppStorage("eventFontSize") var fontSize: Double = 16.0
}