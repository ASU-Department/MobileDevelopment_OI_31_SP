//
//  GitHubTheme.swift
//  Lab1
//
//  Created by UnseenHand on 07.12.2025.
//

import Combine
import SwiftUI

extension Color {
    var uiColor: UIColor {
        UIColor(self)
    }

    init(hex: String) {
        let hex = hex.trimmingCharacters(
            in: CharacterSet.alphanumerics.inverted
        )
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r: UInt64
        let g: UInt64
        let b: UInt64
        switch hex.count {
        case 3:  // RGB (12-bit)
            (r, g, b) = (
                ((int >> 8) * 17), ((int >> 4 & 0xF) * 17), ((int & 0xF) * 17)
            )
        case 6:  // RGB (24-bit)
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}

enum GitHubTheme {
    static let background = Color(hex: "#0D1117")
    static let elevated = Color(hex: "#161B22")
    static let border = Color(hex: "#30363D")
    static let text = Color(hex: "#C9D1D9")
    static let secondaryText = Color(hex: "#8B949E")
    static let accent = Color(hex: "#58A6FF")
}

struct AppThemeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(GitHubTheme.background.ignoresSafeArea())
            .foregroundStyle(GitHubTheme.text)
            .tint(GitHubTheme.accent)
            .colorScheme(.dark)
    }
}

extension View {
    func appTheme() -> some View {
        modifier(AppThemeModifier())
    }
}
