//
//  ShareSheetController.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import SwiftUI
import UIKit

struct ShareSheetController: UIViewControllerRepresentable {
    var activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ vc: UIActivityViewController, context: Context) {}
}
