import UIKit
import Foundation
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {

    var initialPictures: [AstronomyPicture] = []

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {

        print("AppDelegate launched — generating mock astronomy pictures...")

        initialPictures = [
            AstronomyPicture(
                title: "Andromeda Galaxy",
                description: "The nearest spiral galaxy to the Milky Way.",
                urlString: "https://en.wikipedia.org/wiki/Andromeda_Galaxy",
                rating: 0
            ),
            AstronomyPicture(
                title: "The Moon",
                description: "Our natural satellite, visible in the night sky.",
                urlString: "https://en.wikipedia.org/wiki/Moon",
                rating: 0
            ),
            AstronomyPicture(
                title: "Mars",
                description: "The Red Planet in our solar system.",
                urlString: "https://en.wikipedia.org/wiki/Mars",
                rating: 0
            )
        ]

        return true
    }
}

