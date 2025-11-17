//
//  AppDelegate.swift
//  Lab2_TimeCapsule
//
//  Created by User on 26.10.2025.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {

    var initialEvents: [HistoricalEvent] = []

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {

        print("AppDelegate launched — generating mock data...")

        initialEvents = [
            HistoricalEvent(text: "1492 — Columbus discovers America", urlString: "https://en.wikipedia.org/wiki/Christopher_Columbus", isFavorite: true),
            HistoricalEvent(text: "1969 — Apollo 11 lands on the Moon", urlString: "https://en.wikipedia.org/wiki/Apollo_11", isFavorite: false),
            HistoricalEvent(text: "2007 — First iPhone is released", urlString: "https://en.wikipedia.org/wiki/IPhone_(1st_generation)", isFavorite: false)
        ]

        return true
    }
}
