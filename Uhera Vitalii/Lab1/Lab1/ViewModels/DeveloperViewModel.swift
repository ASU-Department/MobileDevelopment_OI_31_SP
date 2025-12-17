//
//  DeveloperViewModel.swift
//  Lab1
//
//  Created by UnseenHand on 07.12.2025.
//


import Foundation
import Combine

@MainActor
final class DeveloperViewModel: ObservableObject {
    @Published var profile: DeveloperProfile

    init(profile: DeveloperProfile) {
        self.profile = profile
    }
}
