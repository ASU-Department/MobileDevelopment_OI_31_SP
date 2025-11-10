//
//  ExpenseDetailViewController.swift
//  BudgetBuddy
//
//  Created by Nill on 10.11.2025.
//

import UIKit
import SwiftUI

class ExpenseDetailViewController: UIViewController {
    var expense: Expense?
    
    private let titleLabel = UILabel()
    private let amountLabel = UILabel()
    private let dateLabel = UILabel()
    private let priorityLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        displayData()
    }
    
    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [titleLabel, amountLabel, dateLabel, priorityLabel])
        stack.axis = .vertical
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        [titleLabel, amountLabel, dateLabel, priorityLabel].forEach {
            $0.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            $0.textAlignment = .center
        }
    }
    
    private func displayData() {
        guard let expense = expense else { return }
        titleLabel.text = "\(expense.title)"
        amountLabel.text = "\(String(format: "%.2f ₴", expense.amount))"
        dateLabel.text = "\(formattedDate(expense.date))"
        priorityLabel.text = "Priority: \(Int(expense.priority * 100))%"
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
