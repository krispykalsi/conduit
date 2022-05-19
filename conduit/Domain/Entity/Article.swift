//
//  article.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

import Foundation

struct Article: Codable {
    var slug: String
    var title: String
    var description: String
    var body: String
    var tagList: [String]
    var createdAt: Date
    var updatedAt: Date
    var favorited: Bool
    var favoritesCount: Int
    var author: Profile
}
