//
//  ContentView.swift
//  Lab1_ParkExplorer
//
//  Created by Vitalik on 27.10.2025.
//

import SwiftUI
import MapKit

struct Park: Identifiable {
    let id = UUID()
    let name: String
    let state: String
    let description: String
    let coordinate: CLLocationCoordinate2D
}

struct FavoriteButton: View {
    @Binding var isFavorite: Bool

    var body: some View {
        Button(action: { isFavorite.toggle() }) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(isFavorite ? .red : .gray)
                .imageScale(.large)
        }
        .buttonStyle(.plain)
    }
}

struct ParkRowView: View {
    let park: Park
    @State private var isFavorite = false

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(park.name)
                    .font(.headline)
                Text(park.state)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            FavoriteButton(isFavorite: $isFavorite)
        }
        .padding(.vertical, 6)
    }
}

struct ParkDetailView: View {
    let park: Park
    @State private var isFavorite = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                HStack {
                    Text(park.name)
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    FavoriteButton(isFavorite: $isFavorite)
                }

                Text(park.description)
                    .font(.body)
                    .padding(.horizontal, 2)

                Map(position: .constant(
                    MapCameraPosition.region(
                        MKCoordinateRegion(
                            center: park.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )
                    )
                )) {
                    Marker(park.name, coordinate: park.coordinate)
                }
                .frame(height: 250)
                .cornerRadius(12)
                .shadow(radius: 4)
            }
            .padding()
        }
        .navigationTitle(park.state)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContentView: View {
    @State private var searchText = ""

    let parks = [
        Park(
            name: "Yellowstone",
            state: "Wyoming",
            description: "Oldest national park in the U.S., known for geysers and wildlife.",
            coordinate: CLLocationCoordinate2D(latitude: 44.6, longitude: -110.5)
        ),
        Park(
            name: "Yosemite",
            state: "California",
            description: "Famous for giant sequoias, waterfalls, and El Capitan cliffs.",
            coordinate: CLLocationCoordinate2D(latitude: 37.8651, longitude: -119.5383)
        ),
        Park(
            name: "Grand Canyon",
            state: "Arizona",
            description: "Iconic canyon carved by the Colorado River, offering breathtaking views.",
            coordinate: CLLocationCoordinate2D(latitude: 36.1069, longitude: -112.1129)
        )
    ]

    var filteredParks: [Park] {
        if searchText.isEmpty { return parks }
        return parks.filter {
            $0.name.lowercased().contains(searchText.lowercased()) ||
            $0.state.lowercased().contains(searchText.lowercased())
        }
    }

    var body: some View {
        NavigationView {
            List(filteredParks) { park in
                NavigationLink(destination: ParkDetailView(park: park)) {
                    ParkRowView(park: park)
                }
            }
            .navigationTitle("National Parks")
            .searchable(text: $searchText, prompt: "Search parks...")
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
