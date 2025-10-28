//
//  UIKitRepresentables.swift
//  SportsHubDemo
//
//  Created by Maksym on 29.10.2025.
//

import SwiftUI
import UIKit

// MARK: - UIViewRepresentable (UISlider)
struct UISliderRepresentable: UIViewRepresentable {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    
    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        
        slider.minimumValue = Float(range.lowerBound)
        slider.maximumValue = Float(range.upperBound)
        slider.value = Float(value)
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged)
        
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        if uiView.value != Float(value) {
            uiView.value = Float(value)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(value: $value, step: step)
    }
    
    final class Coordinator: NSObject {
        var value: Binding<Double>
        let step: Double
        
        init(value: Binding<Double>, step: Double) {
            self.value = value
            self.step = step
        }
        
        @objc func valueChanged(_ sender: UISlider) {
            let raw = Double(sender.value)
            let snapped = (raw / step).rounded() * step
            
            if raw != snapped {
                sender.value = Float(snapped)
            }
            
            value.wrappedValue = snapped
        }
    }
}

// MARK: - UIViewControllerRepresentable (UIActivityViewController)
struct ActivityViewControllerRepresentable: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
