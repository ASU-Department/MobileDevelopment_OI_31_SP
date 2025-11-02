//
//  IntensitySliderRepresentable.swift
//  lab1
//
//  Created by A-Z pack group on 02.11.2025.
//
import SwiftUI
import UIKit

struct IntensitySliderRepresentable: UIViewRepresentable {
    @Binding var value: Double

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = Float(value)
        slider.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .valueChanged)
        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        if uiView.value != Float(value) {
            uiView.value = Float(value)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(value: $value)
    }

    final class Coordinator: NSObject {
        var value: Binding<Double>
        init(value: Binding<Double>) { self.value = value }
        @objc func changed(_ sender: UISlider) {
            value.wrappedValue = Double(sender.value)
        }
    }
}
