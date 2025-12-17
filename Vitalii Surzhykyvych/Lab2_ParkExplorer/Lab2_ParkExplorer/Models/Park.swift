//
//  Park.swift
//  Lab2_ParkExplorer
//
//  Created by Vitalik on 17.12.2025.
//

import Foundation
import MapKit

struct Park: Identifiable {
    let id = UUID()
    let name: String
    let state: String
    let description: String
    let coordinate: CLLocationCoordinate2D
    var isFavorite: Bool = false
}
