//
//  ContentView.swift
//  app
//
//  Created by Наталія Вишинська on 01.11.2025.
//

import SwiftUI

// Модель фільму
struct Movie: Identifiable {
    let id = UUID()
    let title: String
    var rating: Int // 0..5
}

// Головний екран
struct ContentView: View {
    @State private var movies = [
        Movie(title: "Оппенгеймер", rating: 4),
        Movie(title: "Дюна 2", rating: 5),
        Movie(title: "Інтерстеллар", rating: 3),
        Movie(title: "Темний лицар", rating: 5)
    ]
    
    var body: some View {
        NavigationStack {
            List($movies) { $movie in     MovieRow(movie: $movie)
                }
            .navigationTitle("CineGuide")
        }
    }
}

// Рядок фільму
struct MovieRow: View {
    @Binding var movie: Movie
    
    var body: some View {
        HStack {
            Text(movie.title)
                .font(.headline)
            
            Spacer()
            
            ClickableStars(rating: $movie.rating)
        }
        .padding(.vertical, 4)
    }
}

// Клікабельні зірочки
struct ClickableStars: View {
    @Binding var rating: Int
    private let maxRating = 5
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...maxRating, id: \.self) { star in
                Image(systemName: star <= rating ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        rating = star
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
