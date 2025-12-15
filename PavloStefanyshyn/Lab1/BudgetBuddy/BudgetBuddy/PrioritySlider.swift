//
//   PrioritySlider.swift
//  BudgetBuddy
//
//  Created by Nill on 07.12.2025.
//

import SwiftUI
import UIKit
struct Priorityslider: UIViewRepresentable
{
    @Binding var value: Double
    func makeUIView(context: Context) -> UISlider
    {
        let slider = UISlider(frame: .zero)
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        return slider
    }
    func updateUIView(_ uiView: UISlider, context: Context)
    {
        uiView.value = Float(value)
    }
    func makeCoordinator() -> Coordinator
    {
        Coordinator(value: $value)
    }
    class Coordinator: NSObject
    {
        var value: Binding<Double>
        init(value: Binding<Double>)
        {
            self.value = value
        }
        @objc func valueChanged(_ sender: UISlider)
        {
            value.wrappedValue = Double(sender.value)
        }
    }
}
