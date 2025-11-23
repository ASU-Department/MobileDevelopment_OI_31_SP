//
//  ArticleModel.swift
//  Lr2NewsHub
//
//  Created by Pavlo on 22.11.2025.
//

import Foundation
import SwiftData

@Model
class ArticleModel {
    @Attribute(.unique) var id: String
    var title: String
    var text: String
    var category: String
    var isFavorite: Bool
    var userPoint: Int
    var articleUrl: String?
    var imageUrl: String?
    var author: String
    var published: String

    init(
        id: String,
        title: String,
        text: String,
        category: String,
        isFavorite: Bool = false,
        userPoint: Int = 0,
        articleUrl: String? = nil,
        imageUrl: String? = nil,
        author: String,
        published: String
    ) {
        self.id = id
        self.title = title
        self.text = text
        self.category = category
        self.isFavorite = isFavorite
        self.userPoint = userPoint
        self.articleUrl = articleUrl
        self.imageUrl = imageUrl
        self.author = author
        self.published = published
    }
}
