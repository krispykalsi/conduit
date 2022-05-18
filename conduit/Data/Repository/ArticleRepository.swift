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
        return await executeAndCatch({
            return try await dataSource.fetchUserFeed(with: params)
        })
    }
    
    func fetchGlobalFeed(with params: GlobalFeedParams) async -> Result<[Article], Error> {
        return await executeAndCatch({
            return try await dataSource.fetchGlobalFeed(with: params)
        })
    }
    
    func createArticle(withParams params: CreateArticleParams) async -> Result<Article, Error> {
        return await executeAndCatch({
            return try await dataSource.createArticle(withParams: params)
        })
    }
    
    func fetchArticle(viaSlug slug: String) async -> Result<Article, Error> {
        return await executeAndCatch({
            return try await dataSource.fetchArticle(viaSlug: slug)
        })
    }
    
    func updateArticle(viaSlug slug: String, withParams params: UpdateArticleParams) async -> Result<Article, Error> {
        return await executeAndCatch({
            return try await dataSource.updateArticle(viaSlug: slug, withParams: params)
        })
    }
    
    func deleteArticle(viaSlug slug: String) async -> Result<Void, Error> {
        return await executeAndCatch({
            return try await dataSource.deleteArticle(viaSlug: slug)
        })
    }
    
    func fetchComments(ofArticleWithSlug slug: String) async -> Result<[Comment], Error> {
        return await executeAndCatch({
            return try await dataSource.fetchComments(ofArticleWithSlug: slug)
        })
    }
    
    func createComment(onArticleWithSlug slug: String, body: String) async -> Result<Comment, Error> {
        return await executeAndCatch({
            return try await dataSource.createComment(onArticleWithSlug: slug, body: body)
        })
    }
    
    func deleteComment(withId id: Int, onArticleWithSlug slug: String) async -> Result<Void, Error> {
        return await executeAndCatch({
            return try await dataSource.deleteComment(withId: id, onArticleWithSlug: slug)
        })
    }
    
    func favoriteArticle(withSlug slug: String) async -> Result<Article, Error> {
        return await executeAndCatch({
            return try await dataSource.favoriteArticle(withSlug: slug)
        })
    }
    
    func unfavoriteArticle(withSlug slug: String) async -> Result<Article, Error> {
        return await executeAndCatch({
            return try await dataSource.unfavoriteArticle(withSlug: slug)
        })
    }
    
    func fetchTags() async -> Result<[String], Error> {
        return await executeAndCatch({
            return try await dataSource.fetchTags()
        })
    }
}
