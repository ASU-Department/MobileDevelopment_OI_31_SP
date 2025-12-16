//
//  HabitDetailView.swift
//  habitBuddy
//

import SwiftUI
import UIKit

struct SliderView: UIViewRepresentable {
    @Binding var value: Float
    var min: Float = 0
    var max: Float = 100
    
    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)
        slider.minimumValue = min
        slider.maximumValue = max
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        return slider
    }
    
    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = value
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: SliderView
        init(_ parent: SliderView) { self.parent = parent }
        
        @objc func valueChanged(_ sender: UISlider) {
            parent.value = sender.value
        }
    }
}

struct HabitDetailView: View {

    @StateObject var viewModel: HabitDetailViewModel

    var body: some View {
        Form {
            Section(header: Text("Habit Info")) {
                TextField("Name", text: $viewModel.name)
                TextEditor(text: $viewModel.desc)
                    .frame(height: 100)
            }

            Section(header: Text("Progress")) {
                Stepper(
                    "Streak: \(viewModel.streak)",
                    value: $viewModel.streak,
                    in: 0...999
                )

                VStack(alignment: .leading) {
                    Text("Importance: \(Int(viewModel.importance))%")
                    SliderView(
                        value: $viewModel.importance,
                        min: 0,
                        max: 100
                    )
                    .frame(height: 40)
                }
            }
        }
        .navigationTitle(viewModel.name)
        .onDisappear {
            viewModel.saveChanges()
        }
    }
}
