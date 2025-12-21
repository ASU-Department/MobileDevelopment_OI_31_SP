//
//  ActivityIndicatorView.swift
//  Lab1
//
//  Created by UnseenHand on 07.12.2025.
//


import SwiftUI
import UIKit

struct ActivityIndicatorView: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let v = UIActivityIndicatorView(style: style)
        v.hidesWhenStopped = true
        return v
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
