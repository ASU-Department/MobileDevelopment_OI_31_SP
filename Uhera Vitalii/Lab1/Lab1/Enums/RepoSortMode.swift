//
//  RepoSortMode.swift
//  Lab1
//
//  Created by UnseenHand on 11.12.2025.
//


enum RepoSortMode: String, CaseIterable, Identifiable {
    case stars = "Stars"
    case issues = "Issues"
    case alphabet = "A–Z"
    
    var id: String { rawValue }
}
