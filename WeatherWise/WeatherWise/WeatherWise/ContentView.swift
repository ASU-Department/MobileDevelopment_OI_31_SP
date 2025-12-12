//
//  ContentView.swift
//  firstApp
//
//  Created by vburdyk on 13.10.2025.
//

import SwiftUI

struct ContentView: View {
    
    @State private var use24HourFormat: Bool = true
    @State private var locationName: String = "Львів"
    @State private var notificationEnabled: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                
                SimpleTimeFormatToggle(
                    
                    is24Hour: $use24HourFormat
                )
                
                Divider()
                
                LocationInputView(
                    currentLocation: $locationName
                )
                
                Divider()
        
                HStack {
                    Text("Сповіщення про дощ")
                    Spacer()
                    
                    Toggle("", isOn: $notificationEnabled)
                        .labelsHidden()
                }
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Налаштування")
                        .font(.headline)
                        .padding(.bottom, 5)
                    
                    Text("Формат: \(use24HourFormat ? "24 години" : "12 годин")")
                    Text("Місто: \(locationName)")
                    Text("Сповіщення про дощ: \(notificationEnabled ? "Увімкнено" : "Вимкнено")")
                }
                .font(.callout)
                .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Налаштування")
        }
    }
}

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

#Preview {
    ContentView()
}
