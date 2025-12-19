//
//  ParkDetailViewModel.swift
//  Lab5_ParkExplorer
//
//  Created by Vitalik on 19.12.2025.
//

import SwiftUI
import Combine
import MapKit

@MainActor
final class ParkDetailViewModel: ObservableObject {
    let park: ParkAPIModel

    @Published var isFavorite: Bool

    init(park: ParkAPIModel, favoriteParks: Set<String>) {
        self.park = park
        self.isFavorite = favoriteParks.contains(park.id)
    }

    func toggleFavorite() {
        isFavorite.toggle()
    }

    var coordinate: CLLocationCoordinate2D? {
        guard
            let lat = park.latitude,
            let lon = park.longitude,
            let latitude = Double(lat),
            let longitude = Double(lon)
        else { return nil }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
