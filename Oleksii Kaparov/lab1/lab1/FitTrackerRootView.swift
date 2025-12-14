//
//  FitTrackerRootView.swift
//  lab1
//
//  Created by A-Z pack group on 18.11.2025.
//

import Foundation
import SwiftUI

struct FitTrackerRootView: View {
    @StateObject private var viewModel = WorkoutViewModel()
    
    var body: some View {
        NavigationView {
            FitTrackerView(viewModel: viewModel)
        }
    }
}
