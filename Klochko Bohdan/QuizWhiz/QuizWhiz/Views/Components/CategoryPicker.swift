//
//  CategoryPicker.swift
//  QuizWhiz
//
//  Created by Bohdan Klochko on 26.11.2025.
//

import SwiftUI

struct CategoryPicker: View {
    @Binding var selectedCategory: String
    let categories: [String]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Category")
                .font(.headline)

            Picker("Category", selection: $selectedCategory) {
                ForEach(categories, id: \.self) { category in
                    Text(category)
                        .listRowBackground(Color(.systemBackground))
                }
            }
            .pickerStyle(.wheel)
            .padding(.vertical, 6)
            .padding(.horizontal)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .shadow(radius: 2)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}
