//
//  LoadingView.swift
//  lab1
//
//  Created by witold on 23.11.2025.
//

import SwiftUI
import UIKit

struct LoadingView: UIViewRepresentable {
    @Binding var isLoading: Bool

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        if isLoading {
            uiView.startAnimating()
        } else {
            uiView.stopAnimating()
        }
    }
}

