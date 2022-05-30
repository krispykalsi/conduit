//
//  ArticleInteractor.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

protocol ArticleInteractor {
    // MARK: FEED
    func fetchUserFeed(with params: UserFeedParams) async throws -> [Article]
    func fetchGlobalFeed(with params: GlobalFeedParams) async throws -> [Article]
    
    // MARK: ARTICLE
    func createArticle(withParams params: CreateArticleParams) async throws -> Article
    func fetchArticle(viaSlug slug: String) async throws -> Article
    func updateArticle(viaSlug slug: String, withParams params: UpdateArticleParams) async throws -> Article
    func deleteArticle(viaSlug slug: String) async throws
    
    // MARK: COMMENTS
    func fetchComments(ofArticleWithSlug slug: String) async throws -> [Comment]
    func createComment(onArticleWithSlug slug: String, body: String) async throws -> Comment
    func deleteComment(withId id: Int, onArticleWithSlug slug: String) async throws
    
    // MARK: FAVORITE
    func favoriteArticle(withSlug slug: String) async throws -> Article
    func unfavoriteArticle(withSlug slug: String) async throws -> Article
    
    // MARK: TAGS
    func fetchTags() async throws -> [String]
}

// MARK: -
struct UserFeedParams: Codable {
    var limit: Int?
    var offset: Int?
}

struct GlobalFeedParams: Codable {
    var limit: Int?
    var offset: Int?
    var author: String?
    var favorited: String?
    var tag: String?
}

struct CreateArticleParams: Codable {
    var title: String
    var description: String
    var body: String
    var tagList: [String]?
}

struct UpdateArticleParams: Codable {
    var title: String?
    var description: String?
    var body: String?
}
