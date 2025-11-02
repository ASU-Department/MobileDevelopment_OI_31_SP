//
//  AppDelegate.swift
//  lab1
//
//  Created by A-Z pack group on 02.11.2025.
//

import UIKit
import UserNotifications

final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        
        // 1) Seed mock data once
        let seededKey = "mockSeeded"
        if !UserDefaults.standard.bool(forKey: seededKey) {
            let seed = [
                ["name": "Full Body Starter", "exercises": [["name": "Push Ups", "sets": 3, "reps": 12],
                                                            ["name": "Squats",  "sets": 3, "reps": 15]]],
                ["name": "Leg Day", "exercises": [["name": "Lunges", "sets": 4, "reps": 10],
                                                  ["name": "Deadlift (light)", "sets": 3, "reps": 8]]]
            ]
            UserDefaults.standard.set(seed, forKey: "seedWorkouts")
            UserDefaults.standard.set(true, forKey: seededKey)
        }
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            guard granted else { return }
            let content = UNMutableNotificationContent()
            content.title = "Time to train?"
            content.body = "Open the app and log a quick set."
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let req = UNNotificationRequest(identifier: "demo.local.reminder", content: content, trigger: trigger)
            center.add(req, withCompletionHandler: nil)
        }
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
