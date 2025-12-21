//
//  ContentView.swift
//  firstApp
//
//  Created by vburdyk on 13.10.2025.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @StateObject private var vm = SettingsViewModel()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {

                SimpleTimeFormatToggle(is24Hour: $vm.use24HourFormat)

                Divider()

                LocationInputView(currentLocation: $vm.locationName)

                Divider()

                HStack {
                    Text("Сповіщення про дощ")
                    Spacer()
                    Toggle("", isOn: $vm.notificationsEnabled)
                        .labelsHidden()
                }

                Divider()

                NavigationLink("Перейти до деталей погоди") {
                    WeatherDetailView(city: vm.locationName)
                        .navigationTitle("Деталі погоди")
                }
                .buttonStyle(.borderedProminent)

                Spacer()

                VStack(alignment: .leading) {
                    Text("Налаштування")
                        .font(.headline)

                    Text("Формат: \(vm.use24HourFormat ? "24 години" : "12 годин")")
                    Text("Місто: \(vm.locationName)")
                    Text("Сповіщення: \(vm.notificationsEnabled ? "Увімкнено" : "Вимкнено")")
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

//#Preview {
//    ContentView()
//}
