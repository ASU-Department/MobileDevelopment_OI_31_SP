//
//  Lr2NewsHubApp.swift
//  Lr2NewsHub
//
//  Created by Pavlo on 25.10.2025.
//

import SwiftUI
import SwiftData

@main
struct Lr2NewsHubApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: ArticleModel.self)
    }
}
