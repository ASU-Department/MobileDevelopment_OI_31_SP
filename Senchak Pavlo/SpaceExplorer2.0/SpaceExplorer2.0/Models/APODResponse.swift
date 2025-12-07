//
//  APODResponse.swift
//  space3
//
//  Created by Pab1m on 29.11.2025.
//


import Foundation

struct APODResponse: Codable, Hashable {
    let title: String
    let explanation: String
    let url: String
    let media_type: String
}
