//
//  AppSettings.swift
//  Lr2NewsHub
//
//  Created by Pavlo on 22.11.2025.
//

import Foundation
import SwiftUI

class AppSettings: ObservableObject {
    @AppStorage("selectedCategory") var selectedCategory: String = "All"
    @AppStorage("filterFavorite") var filterFavorite: Bool = false
}
