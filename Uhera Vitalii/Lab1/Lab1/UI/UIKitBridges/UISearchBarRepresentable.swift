//
//  UISearchBarRepresentable.swift
//  Lab1
//
//  Created by UnseenHand on 07.12.2025.
//


import SwiftUI
import UIKit

struct UISearchBarRepresentable: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String = ""

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.barTintColor = .black
        searchBar.searchTextField.leftView?.tintColor = GitHubTheme.text.uiColor
        

        let tf = searchBar.searchTextField
        tf.backgroundColor = GitHubTheme.elevated.uiColor
        tf.textColor = GitHubTheme.text.uiColor
        tf.tintColor = GitHubTheme.accent.uiColor   // cursor color
        tf.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: GitHubTheme.secondaryText.uiColor]
        )

        return searchBar
    }

    func updateUIView(_ searchBar: UISearchBar, context: Context) {

        if searchBar.text != text {
            searchBar.text = text
        }
    }
}
