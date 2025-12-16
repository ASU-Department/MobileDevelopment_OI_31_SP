//
//  ContentView.swift
//  habitBuddy
//
//  Created by paul on 17.10.2025.
//
    
import SwiftUI

struct ContentView: View {
    
    @StateObject var habitViewModel: HabitListViewModel
    @StateObject var quoteViewModel: QuoteViewModel
    
    @State private var showAddHabit = false
    let addHabitViewModel: AddHabitViewModel
    
    var body: some View {
        NavigationStack {
            List {
                
                Section {
                    if quoteViewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text(quoteViewModel.quoteText)
                            .font(.footnote)
                            .italic()
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    }
                }
                
                Section(header: Text("Habits")) {
                    
                    if habitViewModel.isLoading {
                        ProgressView()
                    }
                    
                    ForEach(habitViewModel.habits) { habit in
                        NavigationLink {
                            HabitDetailView(
                                viewModel: HabitDetailViewModel(
                                    habit: habit,
                                    repository: habitViewModel.repository
                                )
                            )
                        } label: {
                            HStack {
                                Text(habit.name)
                                Spacer()
                                Text("\(habit.streak)")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        indexSet
                            .map { habitViewModel.habits[$0] }
                            .forEach(habitViewModel.deleteHabit)
                    }
                }
            }
            .refreshable {
                await habitViewModel.loadHabits()
            }
            .navigationTitle("Habits")
            .toolbar {
                Button {
                    showAddHabit = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showAddHabit) {
                AddHabitView(
                    viewModel: addHabitViewModel,
                    onSaved: {
                        Task {
                            await habitViewModel.loadHabits()
                        }
                    }
                )
            }
            .task {
                await habitViewModel.loadHabits()
                await quoteViewModel.loadQuote()
            }
        }
    }
}
