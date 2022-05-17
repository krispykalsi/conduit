//
//  article.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

struct Article: Codable {
    let slug: String
    let title: String
    let description: String
    let body: String
    let tagList: [String]
    let createdAt: String
    let updatedAt: String
    let favorited: Bool
    let favoritesCount: Int
    let author: Profile
}
