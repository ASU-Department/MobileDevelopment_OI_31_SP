//
//  UIKitSliderView.swift
//  Lab1
//
//  Created by UnseenHand on 07.12.2025.
//


import SwiftUI

struct UIKitSliderView: UIViewRepresentable {
    @Binding var value: Int

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 20000
        slider.tintColor = .systemBlue
        
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(value)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: UIKitSliderView
        
        init(_ parent: UIKitSliderView) { self.parent = parent }
        
        @objc func valueChanged(_ sender: UISlider) {
            parent.value = Int(sender.value)
        }
    }
}
