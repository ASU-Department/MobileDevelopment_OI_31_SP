//
//  AppCoordinator.swift
//  BudgetBuddy
//
//  Created by Nill on 12.12.2025.
//

import SwiftUI
import SwiftData
import Combine

import SwiftUI
import SwiftData

final class AppCoordinators: ObservableObject {

    func makeIndexView(context: ModelContext) -> some View {
        let repository = ExpenseRepository()
        let viewModel = IndexViewModel(
            repository: repository,
            context: context
        )
        return IndexView(viewModel: viewModel, coordinator: self)
    }

    func makeAddExpenseView(context: ModelContext) -> some View {
        let repository = ExpenseRepository()
        let viewModel = AddExpenseViewModel(
            repository: repository,
            context: context
        )
        return AddPaymetView(viewModel: viewModel)
    }
}

