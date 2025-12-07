import SwiftUI

struct BrightnessSlider: UIViewRepresentable {

    @Binding var brightness: Double

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = Float(brightness)
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(brightness)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: BrightnessSlider
        init(_ parent: BrightnessSlider) {
            self.parent = parent
        }
        @objc func valueChanged(_ sender: UISlider) {
            parent.brightness = Double(sender.value)
        }
    }
}
