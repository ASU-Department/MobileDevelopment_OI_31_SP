//
//  Models.swift
//  Lab2_TimeCapsule
//
//  Created by User on 22.11.2025.
//

import Foundation
import SwiftData

@Model
class HistoricalEvent {
    @Attribute(.unique) var text: String
    var year: String
    var urlString: String
    var isFavorite: Bool = false
    var dateFetched: Date = Date()
    
    init(text: String, year: String, urlString: String, isFavorite: Bool = false) {
        self.text = text
        self.year = year
        self.urlString = urlString
        self.isFavorite = isFavorite
    }
}

struct WikiAPIResponse: Codable {
    let events: [WikiEventDTO]
}

struct WikiEventDTO: Codable {
    let text: String
    let year: Int
    let pages: [WikiPageDTO]?
}

struct WikiPageDTO: Codable {
    let content_urls: WikiContentUrlsDTO
}

struct WikiContentUrlsDTO: Codable {
    let desktop: WikiPageURLDTO
}

struct WikiPageURLDTO: Codable {
    let page: String
}