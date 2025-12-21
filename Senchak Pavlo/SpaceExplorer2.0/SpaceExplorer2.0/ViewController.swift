import UIKit
import SwiftUI
import SwiftData

class ViewController: UIViewController {

    var container: ModelContainer!

    override func viewDidLoad() {
        super.viewDidLoad()

        container = try? ModelContainer(for: CachedAPOD.self)

        let swiftUIView = MainView()
            .modelContainer(container)

        let hostingController = UIHostingController(rootView: swiftUIView)

        addChild(hostingController)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
}
