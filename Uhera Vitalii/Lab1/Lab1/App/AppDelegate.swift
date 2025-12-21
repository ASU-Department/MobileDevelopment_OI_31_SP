//
//  AppDelegate.swift
//  Lab1
//
//  Created by UnseenHand on 07.12.2025.
//


import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let repos = MockModels.sampleRepos()
        let devs = MockModels.sampleDevelopers()
        print("🔁 Mock data seeded.")

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error { print("Notification auth error:", error) }
            if granted {
                self.scheduleWelcomeNotification()
            }
        }

        initAnalytics()

        return true
    }

    func scheduleWelcomeNotification() {
        let content = UNMutableNotificationContent()
        content.title = "DevHub Ready"
        content.body = "Your DevHub mock data is loaded. Explore trending repos!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let req = UNNotificationRequest(identifier: "devhub.welcome", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(req) { error in
            if let e = error { print("Failed to schedule notification:", e) }
            else { print("🔔 Welcome notification scheduled.") }
        }
    }

    func initAnalytics() {
        print("📊 Analytics initialized — mock session start.")
    }
}
