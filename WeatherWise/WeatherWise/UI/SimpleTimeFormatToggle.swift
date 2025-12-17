//
//  SimpleTimeFormatToggle.swift
//  WeatherWise
//
//  Created by vburdyk on 15.12.2025.
//

import SwiftUI

struct SimpleTimeFormatToggle: View {
    @Binding var is24Hour: Bool

    var body: some View {
        HStack {
            Text("Використовувати 24-годинний формат")
            Spacer()
            Toggle("", isOn: $is24Hour)
                .labelsHidden()
        }
    }
}
