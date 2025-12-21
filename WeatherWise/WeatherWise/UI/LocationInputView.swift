//
//  LocationInputView.swift
//  WeatherWise
//
//  Created by vburdyk on 15.12.2025.
//

import SwiftUI

struct LocationInputView: View {
    @Binding var currentLocation: String

    var body: some View {
        VStack(alignment: .leading) {
            Text("Місто для прогнозу")
                .font(.headline)

            TextField("Введіть назву міста", text: $currentLocation)
                .textFieldStyle(.roundedBorder)
        }
    }
}
