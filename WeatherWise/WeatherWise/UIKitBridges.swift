//
//  MapViewRepresentable.swift
//  WeatherWise
//
//  Created by vburdyk on 16.11.2025.
//

import SwiftUI
import UIKit
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    
    let cityName: String
    let scale: Double
    
    private let cityCoordinates: [String: CLLocationCoordinate2D] = [
        "Львів": CLLocationCoordinate2D(latitude: 49.8397, longitude: 24.0297),
        "Київ": CLLocationCoordinate2D(latitude: 50.4501, longitude: 30.5234),
        "Одеса": CLLocationCoordinate2D(latitude: 46.4825, longitude: 30.7233)
    ]
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
        let coordinate = cityCoordinates[cityName]
        ?? CLLocationCoordinate2D(latitude: 49.8397, longitude: 24.0297)
        
        let span = MKCoordinateSpan(latitudeDelta: scale, longitudeDelta: scale)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        DispatchQueue.main.async {
                uiView.setRegion(region, animated: true)
            }
    }
}

class ScaleSliderViewController: UIViewController {
    
    var onValueChanged: ((Double) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let slider = UISlider(frame: CGRect(x: 20, y: 50, width: 280, height: 30))
        slider.minimumValue = 0.05
        slider.maximumValue = 1.0
        slider.value = 0.3
        
        slider.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        
        view.addSubview(slider)
        view.backgroundColor = .systemGray6
    }
    
    @objc func valueChanged(_ sender: UISlider) {
        onValueChanged?(Double(sender.value))
    }
}

struct MapScaleController: UIViewControllerRepresentable {
    
    @Binding var scale: Double
    
    func makeUIViewController(context: Context) -> ScaleSliderViewController {
        let vc = ScaleSliderViewController()
        
        vc.onValueChanged = { newScale in
            self.scale = newScale
        }
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ScaleSliderViewController, context: Context) {}
}
