//
//  ConduitApiClient.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

import Foundation

final class ConduitApiClient: DataSource {
    internal init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    private let urlSession: URLSession
    
    private static let baseUrl = URL(string: "https://api.realworld.io/api")!
    private let usersEndpoint = baseUrl.appendingPathComponent("users")
    private let userEndpoint = baseUrl.appendingPathComponent("user")
    private let articlesEndpoint = baseUrl.appendingPathComponent("articles")
    private let profilesEndpoint = baseUrl.appendingPathComponent("profiles")
    private let tagsEndpoint = baseUrl.appendingPathComponent("tags")
    
    private func handleBadResponse(_ response: URLResponse, withData data: Data) throws {
        if let httpResponse = response as? HTTPURLResponse {
            switch(httpResponse.statusCode) {
            case 200..<300: debugPrint("sick")
            default: debugPrint("Response Code: \(httpResponse.statusCode)")
                do {
                    let decodedResponse = try JSONDecoder().decode(GenericErrorResponse.self, from: data)
                    debugPrint(decodedResponse.getErrors())
                } catch let error as DecodingError {
                    debugPrint(error.localizedDescription)
                    debugPrint(data)
                }
            }
        }
    }
    
    // MARK: AUTHENTICATION
    func login(withEmail user: LoginViaEmailParams) async throws -> User {
        let url = usersEndpoint.appendingPathComponent("login")
        let body = LoginUserRequest(user: user)
        var req = URLRequest(url: url, method: .post)
        req.httpBody = try JSONEncoder().encode(body)
        let (data, res) = try await urlSession.data(for: req)
        try handleBadResponse(res, withData: data)
        let decodedResponse = try JSONDecoder().decode(UserResponse.self, from: data)
        return decodedResponse.user
    }
    
    func register(withEmail user: RegisterViaEmailParams) async throws -> User {
        let body = RegisterUserRequest(user: user)
        var req = URLRequest(url: usersEndpoint, method: .post)
        req.httpBody = try JSONEncoder().encode(body)
        let (data, res) = try await urlSession.data(for: req)
        try handleBadResponse(res, withData: data)
        let decodedResponse = try JSONDecoder().decode(UserResponse.self, from: data)
        return decodedResponse.user
    }
    
    // MARK: PROFILE
    func fetchCurrentUser() async throws -> User {
        let req = URLRequest(url: userEndpoint, method: .get)
        let (data, res) = try await urlSession.data(for: req)
        try handleBadResponse(res, withData: data)
        let decodedResponse = try JSONDecoder().decode(UserResponse.self, from: data)
        return decodedResponse.user
    }
    
    func updateUser(with params: UpdateUserParams) async throws -> User {
        let body = UpdateUserRequest(user: params)
        var req = URLRequest(url: userEndpoint, method: .put)
        req.httpBody = try JSONEncoder().encode(body)
        let (data, res) = try await urlSession.data(for: req)
        try handleBadResponse(res, withData: data)
        let decodedResponse = try JSONDecoder().decode(UserResponse.self, from: data)
        return decodedResponse.user
    }
    
    func fetchProfile(with username: String) async throws -> Profile {
        let url = profilesEndpoint.appendingPathComponent(username)
        let req = URLRequest(url: url, method: .get)
        let (data, res) = try await urlSession.data(for: req)
        try handleBadResponse(res, withData: data)
        let decodedResponse = try JSONDecoder().decode(ProfileResponse.self, from: data)
        return decodedResponse.profile
    }
    
    func followProfile(with username: String) async throws -> Profile {
        let url = profilesEndpoint.appendingPathComponent(username + "/follow")
        let req = URLRequest(url: url, method: .post)
        let (data, res) = try await urlSession.data(for: req)
        try handleBadResponse(res, withData: data)
        let decodedResponse = try JSONDecoder().decode(ProfileResponse.self, from: data)
        return decodedResponse.profile
    }
    
    func unfollowProfile(with username: String) async throws -> Profile {
        let url = profilesEndpoint.appendingPathComponent(username + "/follow")
        let req = URLRequest(url: url, method: .delete)
        let (data, res) = try await urlSession.data(for: req)
        try handleBadResponse(res, withData: data)
        let decodedResponse = try JSONDecoder().decode(ProfileResponse.self, from: data)
        return decodedResponse.profile
    }
    
    // MARK: FEED
    func fetchUserFeed(with params: UserFeedParams) async throws -> [Article] {
        let url = articlesEndpoint.appendingPathComponent("feed")
        var urlWithParams = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlWithParams.queryItems = (try params.dictionary()).map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
        let req = URLRequest(url: urlWithParams.url!, method: .get)
        let (data, res) = try await urlSession.data(for: req)
        try handleBadResponse(res, withData: data)
        let decodedResponse = try JSONDecoder().decode(MultipleArticlesResponse.self, from: data)
        return decodedResponse.articles
    }
    
    func fetchGlobalFeed(with params: GlobalFeedParams) async throws -> [Article] {
        var urlWithParams = URLComponents(url: articlesEndpoint, resolvingAgainstBaseURL: true)!
        urlWithParams.queryItems = (try params.dictionary()).map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
        let req = URLRequest(url: urlWithParams.url!, method: .get)
        let (data, res) = try await urlSession.data(for: req)
        try handleBadResponse(res, withData: data)
        let decodedResponse = try JSONDecoder().decode(MultipleArticlesResponse.self, from: data)
        return decodedResponse.articles
    }
    
    // MARK: ARTICLE
    func createArticle(withParams params: CreateArticleParams) async throws -> Article {
        var req = URLRequest(url: articlesEndpoint, method: .post)
        let body = CreateArticleRequest(article: params)
        req.httpBody = try JSONEncoder().encode(body)
        let (data, res) = try await urlSession.data(for: req)
        try handleBadResponse(res, withData: data)
        let decodedResponse = try JSONDecoder().decode(SingleArticleResponse.self, from: data)
        return decodedResponse.article
    }
    
    func fetchArticle(viaSlug slug: String) async throws -> Article {
        let url = articlesEndpoint.appendingPathComponent(slug)
        let req = URLRequest(url: url, method: .get)
        let (data, res) = try await urlSession.data(for: req)
        try handleBadResponse(res, withData: data)
        let decodedResponse = try JSONDecoder().decode(SingleArticleResponse.self, from: data)
        return decodedResponse.article
    }
    
    func updateArticle(viaSlug slug: String, withParams params: UpdateArticleParams) async throws -> Article {
        let url = articlesEndpoint.appendingPathComponent(slug)
        var req = URLRequest(url: url, method: .put)
        let body = UpdateArticleRequest(article: params)
        req.httpBody = try JSONEncoder().encode(body)
        let (data, res) = try await urlSession.data(for: req)
        try handleBadResponse(res, withData: data)
        let decodedResponse = try JSONDecoder().decode(SingleArticleResponse.self, from: data)
        return decodedResponse.article
    }
    
    func deleteArticle(viaSlug slug: String) async throws {
        let url = articlesEndpoint.appendingPathComponent(slug)
        let req = URLRequest(url: url, method: .delete)
        let (data, res) = try await urlSession.data(for: req)
        try handleBadResponse(res, withData: data)
    }
    
    // MARK: COMMENTS
    func fetchComments(ofArticleWithSlug slug: String) async throws -> [Comment] {
        let url = articlesEndpoint.appendingPathComponent(slug + "/comments")
        let req = URLRequest(url: url, method: .get)
        let (data, res) = try await urlSession.data(for: req)
        try handleBadResponse(res, withData: data)
        let decodedResponse = try JSONDecoder().decode(MultipleCommentsResponse.self, from: data)
        return decodedResponse.comments
    }
    
    func createComment(onArticleWithSlug slug: String, body: String) async throws -> Comment {
        let url = articlesEndpoint.appendingPathComponent(slug + "/comments")
        var req = URLRequest(url: url, method: .post)
        let body = NewCommentRequest(withBody: body)
        req.httpBody = try JSONEncoder().encode(body)
        let (data, res) = try await urlSession.data(for: req)
        try handleBadResponse(res, withData: data)
        let decodedResponse = try JSONDecoder().decode(SingleCommentResponse.self, from: data)
        return decodedResponse.comment
    }
    
    func deleteComment(withId id: Int, onArticleWithSlug slug: String) async throws {
        let url = articlesEndpoint.appendingPathComponent( "\(slug)/comments/\(id)")
        let req = URLRequest(url: url, method: .delete)
        let (data, res) = try await urlSession.data(for: req)
        try handleBadResponse(res, withData: data)
    }
    
    // MARK: FAVORITE
    func favoriteArticle(withSlug slug: String) async throws -> Article {
        let url = articlesEndpoint.appendingPathComponent( "\(slug)/favorite")
        let req = URLRequest(url: url, method: .post)
        let (data, res) = try await urlSession.data(for: req)
        try handleBadResponse(res, withData: data)
        let decodedResponse = try JSONDecoder().decode(SingleArticleResponse.self, from: data)
        return decodedResponse.article
    }
    
    func unfavoriteArticle(withSlug slug: String) async throws -> Article {
        let url = articlesEndpoint.appendingPathComponent( "\(slug)/favorite")
        let req = URLRequest(url: url, method: .delete)
        let (data, res) = try await urlSession.data(for: req)
        try handleBadResponse(res, withData: data)
        let decodedResponse = try JSONDecoder().decode(SingleArticleResponse.self, from: data)
        return decodedResponse.article
    }
    
    // MARK: TAGS
    func fetchTags() async throws -> [String] {
        let req = URLRequest(url: tagsEndpoint, method: .get)
        let (data, res) = try await urlSession.data(for: req)
        try handleBadResponse(res, withData: data)
        let decodedResponse = try JSONDecoder().decode(TagResponse.self, from: data)
        return decodedResponse.tags
    }
}
