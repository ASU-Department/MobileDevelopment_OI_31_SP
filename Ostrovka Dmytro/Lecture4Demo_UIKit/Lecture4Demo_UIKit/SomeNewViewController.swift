//
//  SomeNewViewController.swift
//  Lecture4Demo_UIKit
//
//  Created by Dmytro Ostrovka on 20.10.2025.
//

import UIKit
import SwiftUI
import MapKit

class SomeNewViewModel {
    let buttonTitle: String = "Hello World!"

    func makeNewViewController() -> UIViewController {
        print("We did it!")
        let newView = ContentView()
        return UIHostingController(rootView: newView)
    }
}

class SomeNewViewController: UIViewController {
    let viewModel = SomeNewViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        let buttonAction = UIAction { _ in
            let newViewController = self.viewModel.makeNewViewController()
            self.navigationController?.pushViewController(newViewController, animated: true)
        }

        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(viewModel.buttonTitle, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addAction(buttonAction, for: .touchUpInside)

        self.view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
}

class MapView: UIView {
    var mapView: MKMapView?

    override init(frame: CGRect) {
        super.init(frame: frame)

        let mapView = MKMapView(frame: frame)
        mapView.translatesAutoresizingMaskIntoConstraints = false

        self.mapView = mapView

        self.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: self.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct SwiftUIMapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MapView {
        MapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: MapView, context: Context) {
        // Update the view if needed
    }
}
