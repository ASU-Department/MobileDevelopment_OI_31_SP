//
//  ContentView.swift
//  habitBuddy
//
//  Created by paul on 17.10.2025.
//
	
import SwiftUI

// identifiable protocol to aknowlenge swiftUI that every element have unique id. Without it swiftUI couldn't know which row was modified
struct Habit: Identifiable {
    // UUID() - Universally Unique ID creating unique id for every entry. let - 'cause id won't change.
    let id = UUID()
    // var - 'cause streak will be changed. For name at this point let will be ok, but better to write var, 'cause maybe i'll modify `Add new habit` and user will have option to change name
    var name: String
    var streak: Int
}

// decodable 
struct QuoteResponse: Decodable {
    let q: String
    let a: String
}

// view for every habit row
struct HabitRow: View {
    // Binding creating references to valuebles, not copies. So every change in struct Habit will be seen in ContentView
    @Binding var habit: Habit
    
    var body: some View {
        HStack {
            Text(habit.name)
                .font(.headline)
            
            Spacer() // tabulation between elements
            
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
    // state to change data without reload
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
                        // loading page than "Loading.. will be repleaced with quote
                        await fetchQuote()
                    }
                }
            
            List {
                // $habits creates ref to whole array
                // $habit ref to every element
                // habit just to show data
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
        // guard used to avoid crash
        guard let url = URL(string: "https://zenquotes.io/api/today") else {
            quote = "Failed to load quote."
            return
        }
        do {
            // URLSession... makes an http-request and returning (Data, URLResponse)
            let(data, _) = try await URLSession.shared.data(from: url)
            // try? is except of dropping error return nil(null in swift)
            if let decoded = try?
                // Decoder : JSON -> Swift struct
                // decode... means try read data as QuoteResponse. If u can't drop null, 'cause of try?
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
