//
//  SliderView.swift
//  Lr2NewsHub
//
//  Created by Pavlo on 05.11.2025.
//

import SwiftUI
import UIKit

struct SliderView: UIViewRepresentable {
    @Binding var userPoint: Int
    
    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.minimumValue = 0
        slider.maximumValue = 5
        slider.value = Float(userPoint)
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(userPoint)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(value: $userPoint)
    }
    
    class Coordinator: NSObject {
        var value: Binding<Int>
        
        init(value: Binding<Int>) {
            self.value = value
        }
        
        @objc func valueChanged(_ sender: UISlider) {
            value.wrappedValue = Int(sender.value)
        }
    }
}
