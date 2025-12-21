//
//  DeveloperViewModel.swift
//  Lab1
//
//  Created by UnseenHand on 07.12.2025.
//

import Combine
import Foundation

@MainActor
final class DeveloperProfileViewModel: ObservableObject {
    @Published var profile: DeveloperProfile

    init(profile: DeveloperProfile) {
        self.profile = profile
    }
}
