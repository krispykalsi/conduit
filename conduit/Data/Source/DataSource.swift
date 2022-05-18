//
//  RemoteDataSource.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

protocol DataSource {
    // MARK: AUTHENTICATION
    func login(withEmail user: LoginViaEmailParams) async throws -> User
    func register(withEmail user: RegisterViaEmailParams) async throws -> User
    
    // MARK: PROFILE
    func fetchCurrentUser() async throws -> User
    func updateUser(with params: UpdateUserParams) async throws -> User
    func fetchProfile(with username: String) async throws -> Profile
    func followProfile(with username: String) async throws -> Profile
    func unfollowProfile(with username: String) async throws -> Profile
    
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
