//
//  ShareSheetView.swift
//  Lab1
//
//  Created by UnseenHand on 07.12.2025.
//


import SwiftUI
import UIKit

struct ShareSheetView: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        let label = UILabel()
        label.text = "SheetContent"
        label.accessibilityIdentifier = "ShareSheetDetails"
        
        vc.view.addSubview(label)
        
        return vc
    }

    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
