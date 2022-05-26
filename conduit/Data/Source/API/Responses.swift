//
//  Responses.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//


struct GenericErrorResponse: Decodable {
    private let errors: [String: [String]]
    func getErrors() -> [String] { errors["body"] ?? [] }
}

struct UserResponse: Decodable {
    let user: User
}

struct ProfileResponse: Decodable {
    let profile: Profile
}

struct MultipleArticlesResponse: Decodable {
    let articles: [Article]
    let articlesCount: Int
}

struct SingleArticleResponse: Decodable {
    let article: Article
}

struct MultipleCommentsResponse: Decodable {
    let comments: [Comment]
}

struct SingleCommentResponse: Decodable {
    let comment: Comment
}

struct TagResponse: Decodable {
    let tags: [String]
}
