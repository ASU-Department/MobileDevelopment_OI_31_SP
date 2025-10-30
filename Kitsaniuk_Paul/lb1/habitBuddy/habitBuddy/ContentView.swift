//
//  ContentView.swift
//  habitBuddy
//
//  Created by paul on 17.10.2025.
//	
	
import SwiftUI

struct Habit: Identifiable {
    let id = UUID()
    var name: String
    var streak: Int
}

struct QuoteResponse: Decodable {
    let q: String
    let a: String
}

struct HabitRow: View {
    @Binding var habit: Habit
    
    var body: some View {
        HStack {
            Text(habit.name)
                .font(.headline)
            
            Spacer()
            
            Button("Done") {
                habit.streak += 1
            }
            .buttonStyle(.borderedProminent)
            .frame(width: 80)
            
            Spacer()
            
            Text("\(habit.streak)")
                .font(.subheadline)
        }
        .padding(.vertical, 6)
    }
}

struct ContentView: View {
    @State private var habits: [Habit] = [
        Habit(name: "8 hour sleep", streak: 3),
        Habit(name: "10000 steps", streak: 1)
    ]
    
    @State private var quote: String = "Loading..."
    
    var body: some View {
        VStack {
            Text("HabitBuddy")
                .font(.largeTitle.bold())
                .padding(.top, 16)
            
            Text(quote)
                .font(.subheadline)
                .italic()
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .onAppear {
                    Task {
                        await fetchQuote()
                    }
                }
            
            List {
                ForEach($habits) { $habit in
                    HabitRow(habit: $habit)
                }
            }
            
            Button("And new habit") {
                habits.append(Habit(name: "created habit", streak: 0))
            }
            .buttonStyle(.bordered)
            .padding(.bottom, 20)
        }
    }
    
    func fetchQuote() async {
        guard let url = URL(string: "https://zenquotes.io/api/today") else {
            quote = "Failed to load quote."
            return
        }
        do {
            let(data, _) = try await URLSession.shared.data(from: url)
            if let decoded = try?
                JSONDecoder().decode([QuoteResponse].self, from: data),
               let first = decoded.first { quote = "\"\(first.q)\" - \(first.a)"
            } else {
                quote = "Could not parse quote."
            }
        } catch {
            quote = "Error loading quote."
        }
    }
}

#Preview {
    ContentView()
}
