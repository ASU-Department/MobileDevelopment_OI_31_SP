//
//  NetworkError.swift
//  Lab1
//
//  Created by UnseenHand on 15.12.2025.
//

import Foundation


enum NetworkError: LocalizedError {
    case invalidResponse
    case offline

    var errorDescription: String? {
        switch self {	
        case .invalidResponse:
            return "Invalid server response"
        case .offline:
            return "You appear to be offline"
        }
    }
}
