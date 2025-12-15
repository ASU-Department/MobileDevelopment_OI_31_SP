//
//  Lab1App.swift
//  Lab1
//
//  Created by UnseenHand on 15.11.2025.
//

import SwiftUI

@main
struct Lab1App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RepoHubSearchView()
        }
    }
}
