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
    var range: ClosedRange<Double>

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(title): \(value)")
                Spacer()
            }

            Slider(
                value: $value.doubleValue,
                in: range
            )
        }
        .padding(.horizontal)
    }
}
