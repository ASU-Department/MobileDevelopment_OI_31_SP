//
//  HabitDetailView.swift
//  habitBuddy
//

import SwiftUI
import UIKit
import SwiftData

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
    @Bindable var habit: Habit
    @Environment(\.modelContext) private var modelContext
    
    @State private var importance: Float = 50
    
    var body: some View {
        Form {
            Section(header: Text("Habit Info")) {
                TextField("Name", text: Binding(
                    get: { habit.name },
                    set: { new in
                        habit.name = new
                        save()
                    }
                ))
                TextEditor(text:Binding(
                    get: { habit.desc },
                    set: { new in
                        habit.desc = new
                        save()
                    }
                ))
                .frame(height: 100)
            }
            
            Section(header: Text("Progress")) {
                Stepper("Streak: \(habit.streak)", value: Binding(
                    get: { habit.streak },
                    set: { new in habit.streak = new
                        save()
                    }
                ), in: 0...999)
                
                VStack(alignment: .leading) {
                    Text("Importance: \(Int(importance))%")
                    SliderView(value: $importance, min: 0, max: 100)
                        .frame(height: 40)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle(habit.name)
        .onAppear {
            importance = 50
        }
    }
    
    private func save() {
        do {
            try modelContext.save()
        } catch {
            print("Failed  to save habit changes: \(error)")
        }
    }
}

#Preview {
    HabitDetailView(habit: Habit(name: "Test", desc: "Demo desc", streak: 5))
        .modelContainer(for: [Habit.self])
}
