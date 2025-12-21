//
//  ShareArticle.swift
//  Lr2NewsHub
//
//  Created by Pavlo on 22.11.2025.
//

import SwiftUI

struct ShareArticle: UIViewControllerRepresentable {
    let items: [String]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
