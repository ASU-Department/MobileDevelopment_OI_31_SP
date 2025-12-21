//
//  FilterValueInputRow.swift
//  Lab1
//
//  Created by UnseenHand on 11.12.2025.
//

import SwiftUI

struct FilterValueInputRow: View {
    let title: String
    @Binding var sliderValue: Double
    let range: ClosedRange<Double>
    let usesSlider: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .fontWeight(.medium)
            
            if usesSlider {
                Slider(value: $sliderValue, in: range)
            } else {
                TextField("Enter value", value: $sliderValue, format: .number)
                    .keyboardType(.numberPad)
                    .padding(8)
                    .background(GitHubTheme.background)
                    .cornerRadius(8)
            }
            
            Text("\(Int(sliderValue))")	
                .foregroundStyle(.secondary)
                .font(.caption)
        }
        .padding(.horizontal)
    }
}
