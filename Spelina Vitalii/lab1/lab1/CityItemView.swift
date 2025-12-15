//
//  CityItemView.swift
//  lab1
//
//  Created by witold on 07.11.2025.
//

import SwiftUI

struct CityItemView: View {
    @Bindable var city: City

    var body: some View {
        HStack(spacing: 15) {
            Circle()
                .fill(city.color)
                .frame(width: 10, height: 10)
            
            if city.selected {
                Image(systemName: "pin.fill")
                    .foregroundColor(.blue)
            }

            VStack(alignment: .leading) {
                Text(city.name)
                    .font(.headline)
                Text("AQI: \(city.aqi)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 5)
    }
}
