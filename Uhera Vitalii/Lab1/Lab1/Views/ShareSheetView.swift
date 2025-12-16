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
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
