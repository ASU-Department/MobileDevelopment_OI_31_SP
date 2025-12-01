//
//  ActivityViewControllerRepresentable.swift
//  lab1
//
//  Created by A-Z pack group on 02.11.2025.
//
import SwiftUI
import UIKit

struct ActivityViewControllerRepresentable: UIViewControllerRepresentable {
    let items: [Any]
    var completion: ((Bool) -> Void)? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        vc.completionWithItemsHandler = { _, completed, _, _ in
            completion?(completed)
        }
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
