//
//  Lr2NewsHubApp.swift
//  Lr2NewsHub
//
//  Created by Pavlo on 25.10.2025.
//

import SwiftUI

@main
struct Lr2NewsHubApp: App {
    @UIApplicationDelegateAdaptor(AppDelegateMockData.self) var appDelegateMockData
    
    var body: some Scene {
        WindowGroup {
            ContentView(news: appDelegateMockData.news, categories: appDelegateMockData.categories)
        }
    }
}
