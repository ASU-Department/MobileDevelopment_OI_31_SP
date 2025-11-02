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
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        
        configureNotifications()
        scheduleDemoReminderIfAuthorized()
        return true
    }
    
    private func configureNotifications() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
    
    private func scheduleDemoReminderIfAuthorized() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else { return }
            let content = UNMutableNotificationContent()
            content.title = "Time to train?"
            content.body = "Open the app and log a quick set."
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let req = UNNotificationRequest(
                identifier: "demo.local.reminder",
                content: content,
                trigger: trigger
            )
            UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
