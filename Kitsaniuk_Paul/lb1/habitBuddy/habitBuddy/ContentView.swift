//
//  ContentView.swift
//  habitBuddy
//
//  Created by paul on 17.10.2025.
//
    
import SwiftUI
import SwiftData

struct QuoteResponse: Decodable {
    let q: String
    let a: String
}

struct HabitRow: View {
    @Bindable var habit: Habit
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        HStack {
            Text(habit.name)
                .font(.headline)
            
            Spacer()
            
            Button("Done") {
                habit.streak += 1
                do {
                    try modelContext.save()
                } catch {
                    print("Failed saving streak: \(error)")
                }
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
    @Environment(\.modelContext) private var modelContext
    @Query private var habits: [Habit]
    
    @State private var quote: String = "Loading..."
    @State private var isLoading = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var showAddHabit = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("HabitBuddy")
                    .font(.largeTitle.bold())
                    .padding(.top, 16)

                if isLoading {
                    ProgressView("Loading quote...")
                        .padding()
                } else {
                    Text(quote)
                        .font(.subheadline)
                        .italic()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                if habits.isEmpty {
                    Text("No habits yet - add your first habit")
                        .foregroundStyle(.secondary)
                        .padding(.top, 20)
                }
                
                List {
                    ForEach(habits) { habit in
                        NavigationLink(destination: HabitDetailView(habit: habit)) {
                            HabitRow(habit: habit)
                        }
                    }
                    .onDelete(perform: delete)
                }
                .refreshable { await fetchQuote() }

                Button("Add New Habit") {
                    showAddHabit = true
                }
                .buttonStyle(.bordered)
                .padding(.bottom, 20)
                .sheet(isPresented: $showAddHabit) {
                    AddHabitView(modelContext: modelContext)
                }
            }
            .onAppear {
                Task { await fetchQuote() }
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let h = habits[index]
            modelContext.delete(h)
        }
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete: \(error)")
        }
    }
    
    func fetchQuote() async {
        isLoading = true
        
        guard let url = URL(string: "https://zenquotes.io/api/today") else {
            loadCachedQuote()
            showError("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decoded = try? JSONDecoder().decode([QuoteResponse].self, from: data),
               let first = decoded.first {
                
                let formatted = "\"\(first.q)\" - \(first.a)"
                quote = formatted
                
                UserDefaults.standard.set(formatted, forKey: "cachedQuote")
            } else {
                loadCachedQuote()
                showError("Could not parse quote")
            }
            
        } catch {
            loadCachedQuote()
            showError("No internet connection")
        }
        
        isLoading = false
    }

    func loadCachedQuote() {
        if let saved = UserDefaults.standard.string(forKey: "cachedQuote") {
            quote = saved + " (offline)"
        } else {
            quote = "No saved quote available."
        }
    }

    func showError(_ message: String) {
        errorMessage = message
        showErrorAlert = true
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Habit.self])
}
