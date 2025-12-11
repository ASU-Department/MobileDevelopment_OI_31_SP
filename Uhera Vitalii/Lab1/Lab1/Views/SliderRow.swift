//
//  SliderRow.swift
//  Lab1
//
//  Created by UnseenHand on 16.11.2025.
//


import SwiftUI

struct SliderRow: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Double>

    @State private var isEditingValue = false
    @State private var tempValue = ""

    var body: some View {
        VStack(alignment: .leading) {

            HStack {
                Text(title)

                Spacer()

                if isEditingValue {
                    TextField("", text: $tempValue, onCommit: commitValue)
                        .frame(width: 60)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                } else {
                    Text("\(value)")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            tempValue = "\(value)"
                            isEditingValue = true
                        }
                }
            }

            Slider(value: $value.doubleValue, in: range)
                .tint(.blue)
        }
        .padding(.horizontal)
        .colorScheme(.dark)
    }

    private func commitValue() {
        if let newVal = Int(tempValue) {
            let clamped = Int(min(max(Double(newVal), range.lowerBound), range.upperBound))
            value = clamped
        }
        isEditingValue = false
    }
}


#Preview {
    @Previewable @State var val = 20
    SliderRow(title: "Title", value: $val, range: 0.0...100.0)
}
