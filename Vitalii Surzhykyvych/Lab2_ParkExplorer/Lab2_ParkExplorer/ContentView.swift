//
//  ContentView.swift
//  Lab2_ParkExplorer
//
//  Created by Vitalik on 17.12.2025.
//

import SwiftUI
import MapKit

struct Park: Identifiable {
    let id = UUID()
    let name: String
    let state: String
    let description: String
    let coordinate: CLLocationCoordinate2D
    var isFavorite: Bool = false
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
    @Binding var park: Park

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
            FavoriteButton(isFavorite: $park.isFavorite)
        }
        .padding(.vertical, 6)
    }
}

struct ParkDetailView: View {
    @Binding var park: Park

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                HStack {
                    Text(park.name)
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    FavoriteButton(isFavorite: $park.isFavorite)
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

    @State private var parks: [Park] = [
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

    var filteredParks: [Binding<Park>] {
        $parks.filter { park in
            searchText.isEmpty ||
            park.wrappedValue.name.lowercased().contains(searchText.lowercased()) ||
            park.wrappedValue.state.lowercased().contains(searchText.lowercased())
        }
    }

    var body: some View {
        NavigationView {
            List(filteredParks) { $park in
                NavigationLink(destination: ParkDetailView(park: $park)) {
                    ParkRowView(park: $park)
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
