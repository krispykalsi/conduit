//
//  ArticleInteractor.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

protocol ArticleInteractor {
    // MARK: FEED
    func fetchUserFeed(with params: UserFeedParams) async -> Result<[Article], Error>
    func fetchGlobalFeed(with params: GlobalFeedParams) async -> Result<[Article], Error>
    
    // MARK: ARTICLE
    func createArticle(withParams params: CreateArticleParams) async -> Result<Article, Error>
    func fetchArticle(viaSlug slug: String) async -> Result<Article, Error>
    func updateArticle(viaSlug slug: String, withParams params: UpdateArticleParams) async -> Result<Article, Error>
    func deleteArticle(viaSlug slug: String) async -> Result<Void, Error>
    
    // MARK: COMMENTS
    func fetchComments(ofArticleWithSlug slug: String) async -> Result<[Comment], Error>
    func createComment(onArticleWithSlug slug: String, body: String) async -> Result<Comment, Error>
    func deleteComment(withId id: Int, onArticleWithSlug slug: String) async -> Result<Void, Error>
    
    // MARK: FAVORITE
    func favoriteArticle(withSlug slug: String) async -> Result<Article, Error>
    func unfavoriteArticle(withSlug slug: String) async -> Result<Article, Error>
    
    // MARK: TAGS
    func fetchTags() async -> Result<[String], Error>
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
