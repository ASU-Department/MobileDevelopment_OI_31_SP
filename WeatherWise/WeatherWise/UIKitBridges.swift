//
//  MapViewRepresentable.swift
//  WeatherWise
//
//  Created by vburdyk on 16.11.2025.
//

import SwiftUI
import UIKit
import MapKit

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
