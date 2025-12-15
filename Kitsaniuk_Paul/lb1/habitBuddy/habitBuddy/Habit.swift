//
//  Habit.swift
//  habitBuddy
//
//  Created by  User on 23.11.2025. *i was coding my laptop on lb1, but now my friend borrowed me macbook
//

import Foundation
import SwiftData

@Model
final class Habit: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String
    var desc: String
    var streak: Int
    
    init(name: String, desc: String = "", streak: Int = 0) {
        self.name = name;
        self.desc = desc;
        self.streak = streak;
    }
}
