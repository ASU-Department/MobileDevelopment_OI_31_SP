//
//  StatsUIKitRepresentables.swift
//  SportsHubDemo
//
//  Created by Maksym on 29.10.2025.
//

import SwiftUI
import UIKit
import SafariServices

// MARK: UISegmentedControl <-> SwiftUI
struct SegmentedControlRepresentable: UIViewRepresentable {
    @Binding var selectedIndex: Int
    let segments: [String]
    
    func makeUIView(context: Context) -> UISegmentedControl {
        let control = UISegmentedControl(items: segments)
    
        control.selectedSegmentIndex = selectedIndex
        control.addTarget(
            context.coordinator,
            action: #selector(Coordinator.changed(_:)),
            for: .valueChanged
        )
        
        return control
    }
    
    func updateUIView(_ uiView: UISegmentedControl, context: Context) {
        if uiView.selectedSegmentIndex != selectedIndex {
            uiView.selectedSegmentIndex = selectedIndex
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedIndex: $selectedIndex)
    }
    
    final class Coordinator: NSObject {
        var selectedIndex: Binding<Int>
        init(selectedIndex: Binding<Int>) { self.selectedIndex = selectedIndex }
        @objc func changed(_ sender: UISegmentedControl) { selectedIndex.wrappedValue = sender.selectedSegmentIndex }
    }
}

// MARK: SFSafariViewController bridge
struct SafariViewRepresentable: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: Context) -> SFSafariViewController { SFSafariViewController(url: url) }
    func updateUIViewController(_ vc: SFSafariViewController, context: Context) {}
}
