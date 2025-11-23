//
//  AppDelegate.swift
//  lab1
//
//  Created by witold on 23.11.2025.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    static var cityStore: CityStore?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        if AppDelegate.cityStore == nil {
            AppDelegate.cityStore = CityStore()
            AppDelegate.cityStore?.loadMockData()
        }
        return true
    }
}

