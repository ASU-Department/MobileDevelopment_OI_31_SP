//
//  ContentView.swift
//  ParkExplorer
//
//  Created by Vitalik on 27.10.2025.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @State private var searchText = ""
    @State private var parks: [Park] = [
        Park(
            name: "Yellowstone",
            state: "Wyoming",
            description: "Oldest national park in the U.S., known for geysers and wildlife.",
            coordinate: .init(latitude: 44.6, longitude: -110.5)
        ),
        Park(
            name: "Yosemite",
            state: "California",
            description: "Famous for giant sequoias, waterfalls, and El Capitan cliffs.",
            coordinate: .init(latitude: 37.8651, longitude: -119.5383)
        ),
        Park(
            name: "Grand Canyon",
            state: "Arizona",
            description: "Iconic canyon carved by the Colorado River.",
            coordinate: .init(latitude: 36.1069, longitude: -112.1129)
        )
    ]

    var filteredParks: [Binding<Park>] {
        $parks.filter {
            searchText.isEmpty ||
            $0.wrappedValue.name.localizedCaseInsensitiveContains(searchText) ||
            $0.wrappedValue.state.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            List(filteredParks) { $park in
                NavigationLink {
                    ParkDetailView(park: $park)
                } label: {
                    ParkRowView(park: $park)
                }
            }
            .navigationTitle("National Parks")
            .toolbar {
                NavigationLink(destination: SettingsView()) {
                    Image(systemName: "gear")
                }
            }
            .searchable(text: $searchText)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


#Preview {
    ContentView()
}
