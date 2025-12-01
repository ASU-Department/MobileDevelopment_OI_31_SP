//
//  ShareSheetRepresentable.swift
//  ArtCurator
//
//  Created by Denys Oliinyk on 08.11.2025.
//

import SwiftUI

struct ShareSheetRepresentable: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
    }
}
