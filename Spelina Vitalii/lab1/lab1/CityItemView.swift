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
                .fill(city.color)
                .frame(width: 10, height: 10)

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
