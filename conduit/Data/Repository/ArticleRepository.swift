//
//  ArticleRepository.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

final class ArticleRepository: ArticleInteractor {
    internal init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    private let dataSource: DataSource
    
    func fetchUserFeed(with params: UserFeedParams) async -> Result<[Article], Error> {
        await Task { try await dataSource.fetchUserFeed(with: params) }.result
    }
    
    func fetchGlobalFeed(with params: GlobalFeedParams) async -> Result<[Article], Error> {
        await Task { try await dataSource.fetchGlobalFeed(with: params) }.result
    }
    
    func createArticle(withParams params: CreateArticleParams) async -> Result<Article, Error> {
        await Task { try await dataSource.createArticle(withParams: params) }.result
    }
    
    func fetchArticle(viaSlug slug: String) async -> Result<Article, Error> {
        await Task { try await dataSource.fetchArticle(viaSlug: slug) }.result
    }
    
    func updateArticle(viaSlug slug: String, withParams params: UpdateArticleParams) async -> Result<Article, Error> {
        await Task { try await dataSource.updateArticle(viaSlug: slug, withParams: params) }.result
    }
    
    func deleteArticle(viaSlug slug: String) async -> Result<Void, Error> {
        await Task { try await dataSource.deleteArticle(viaSlug: slug) }.result
    }
    
    func fetchComments(ofArticleWithSlug slug: String) async -> Result<[Comment], Error> {
        await Task { try await dataSource.fetchComments(ofArticleWithSlug: slug) }.result
    }
    
    func createComment(onArticleWithSlug slug: String, body: String) async -> Result<Comment, Error> {
        await Task { try await dataSource.createComment(onArticleWithSlug: slug, body: body) }.result
    }
    
    func deleteComment(withId id: Int, onArticleWithSlug slug: String) async -> Result<Void, Error> {
        await Task { try await dataSource.deleteComment(withId: id, onArticleWithSlug: slug) }.result
    }
    
    func favoriteArticle(withSlug slug: String) async -> Result<Article, Error> {
        await Task { try await dataSource.favoriteArticle(withSlug: slug) }.result
    }
    
    func unfavoriteArticle(withSlug slug: String) async -> Result<Article, Error> {
        await Task { try await dataSource.unfavoriteArticle(withSlug: slug) }.result
    }
    
    func fetchTags() async -> Result<[String], Error> {
        await Task { try await dataSource.fetchTags() }.result
    }
}
