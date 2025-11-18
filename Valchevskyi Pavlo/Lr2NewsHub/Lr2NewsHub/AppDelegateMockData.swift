//
//  AppDelegateMockData.swift
//  Lr2NewsHub
//
//  Created by Pavlo on 25.10.2025.
//

import UIKit

class AppDelegateMockData: NSObject, UIApplicationDelegate {
    var news: [Article] = []
    var categories: [String] = []
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        loadMockData()
        return true
    }
    
    private func loadMockData() {
        categories = ["All"]
        
        for i in 1...5 {
            news.append(Article(title: "Title \(i)", text: "Text \(i)", category: "Category \(i)", userPoint: i))
            categories.append("Category \(i)")
        }
        
        categories.append("My suggest news")
    }
}
