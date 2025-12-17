//
//  ImageStorage.swift
//  Lab2_ParkExplorer
//
//  Created by Vitalik on 17.12.2025.
//

import UIKit

enum ImageStorage {

    static func saveImage(_ image: UIImage, for parkId: UUID) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(data, forKey: parkId.uuidString)
        }
    }

    static func loadImage(for parkId: UUID) -> UIImage? {
        guard
            let data = UserDefaults.standard.data(forKey: parkId.uuidString)
        else { return nil }

        return UIImage(data: data)
    }
}
