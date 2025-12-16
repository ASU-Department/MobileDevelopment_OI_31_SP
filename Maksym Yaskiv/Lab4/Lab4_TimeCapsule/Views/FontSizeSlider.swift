//
//  FontSizeSlider.swift
//  Lab2_TimeCapsule
//
//  Created by User on 26.10.2025.
//

import SwiftUI
import UIKit

struct FontSizeSlider: UIViewRepresentable {
    @Binding var value: Double
    let range: ClosedRange<Float>

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        slider.minimumValue = range.lowerBound
        slider.maximumValue = range.upperBound
        slider.value = Float(value)
        slider.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .valueChanged)
        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(value)
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject {
        var parent: FontSizeSlider
        init(_ parent: FontSizeSlider) { self.parent = parent }
        @objc func changed(_ sender: UISlider) {
            parent.value = Double(sender.value)
        }
    }
}