//
//  MapViewRepresentable.swift
//  WeatherWise
//
//  Created by vburdyk on 15.12.2025.
//

import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {

    let cityName: String
    let scale: Double

    private let cityCoordinates: [String: CLLocationCoordinate2D] = [
        "Львів": .init(latitude: 49.8397, longitude: 24.0297),
        "Київ": .init(latitude: 50.4501, longitude: 30.5234),
        "Одеса": .init(latitude: 46.4825, longitude: 30.7233)
    ]

    func makeUIView(context: Context) -> MKMapView {
        MKMapView()
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let coordinate = cityCoordinates[cityName] ?? cityCoordinates["Львів"]!
        let region = MKCoordinateRegion(
            center: coordinate,
            span: .init(latitudeDelta: scale, longitudeDelta: scale)
        )
        uiView.setRegion(region, animated: true)
    }
}
