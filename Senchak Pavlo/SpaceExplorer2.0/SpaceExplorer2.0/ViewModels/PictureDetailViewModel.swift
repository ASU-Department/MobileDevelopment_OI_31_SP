//
//  PictureDetailViewModel.swift
//  SpaceExplorer2.0
//
//  Created by Pab1m on 13.12.2025.
//

import Combine

final class PictureDetailViewModel: ObservableObject {

    @Published var textSize: Double

    private let settings = SettingsService()

    init() {
        let saved = settings.loadTextSize()
        self.textSize = saved == 0 ? 16 : saved
    }

    func save() {
        settings.saveTextSize(textSize)
    }
}
