//
//  article.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

struct Article: Codable {
    var slug: String
    var title: String
    var description: String
    var body: String
    var tagList: [String]
    var createdAt: String
    var updatedAt: String
    var favorited: Bool
    var favoritesCount: Int
    var author: Profile
}
