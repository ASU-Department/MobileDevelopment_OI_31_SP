//
//  ViewController.swift
//  delete
//
//  Created by Pab1m on 16.11.2025.
//

import UIKit
import SwiftUI
import SwiftData

class ViewController: UIViewController {

    var container: ModelContainer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Ініціалізація SwiftData
        container = try? ModelContainer(for: CachedAPOD.self)

        // Створення SwiftUI головного екрана
        let swiftUIView = MainView()
            .modelContainer(container)

        // Обгортання у HostingController
        let hostingController = UIHostingController(rootView: swiftUIView)

        // Розміщення на весь екран
        addChild(hostingController)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}
