//
//  FontSizeSlider.swift
//  Lab2_TimeCapsule
//
//  Created by User on 26.10.2025.
//

import SwiftUI
import UIKit

struct FontSizeSlider: UIViewRepresentable {
    
    @Binding var value: CGFloat
    let range: ClosedRange<Float>

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        slider.minimumValue = range.lowerBound
        slider.maximumValue = range.upperBound
        
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.onValueChanged),
            for: .valueChanged
        )
        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(value)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
     
    class Coordinator: NSObject {
        var parent: FontSizeSlider

        init(parent: FontSizeSlider) {
            self.parent = parent
        }

        @objc func onValueChanged(_ sender: UISlider) {
            parent.value = CGFloat(sender.value)
        }
    }
}