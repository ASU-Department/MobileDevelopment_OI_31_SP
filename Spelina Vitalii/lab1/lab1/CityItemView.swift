//
//  CityItemView.swift
//  lab1
//
//  Created by witold on 07.11.2025.
//

import SwiftUI

struct CityItemView: View {
    @Binding var city: City
    
    var body: some View {
        HStack(spacing: 15) {
            Circle()
                .fill(getColorByPollutionLvl(for: city.polLevel))
                .frame(width: 10, height: 10)
            
            Toggle(isOn: $city.selected) {
                VStack(alignment: .leading) {
                    Text(city.name)
                        .font(.headline)
                    Text("Pollution: \(city.polLevel, specifier: "%.1f")")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 5)
    }
    
    func getColorByPollutionLvl(for level: Float) -> Color {
        switch level {
            case 0..<2:
                return .green
            case 2..<3:
                return .yellow
            case 3..<4:
                return .orange
            default:
                return .red
        }
    }
}
