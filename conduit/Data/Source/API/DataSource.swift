//
//  DataSource.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 25/05/22.
//

import Foundation

class DataSource {
    private static let baseUrl = URL(string: "https://api.realworld.io/api")!
    private let userEndpoint = baseUrl.appendingPathComponent("user")
    private let articlesEndpoint = baseUrl.appendingPathComponent("articles")
    private let profilesEndpoint = baseUrl.appendingPathComponent("profiles")
    private let tagsEndpoint = baseUrl.appendingPathComponent("tags")
    
    private let httpService: HTTPService
    private let jsonService: JSONService
    
    internal init(httpService: HTTPService, jsonService: JSONService) {
        self.httpService = httpService
        self.jsonService = jsonService
    }
    
    static let shared = DataSource(httpService: HTTPClient.shared,
                                   jsonService: JSONParser.shared)
    
    private func handleBadResponse(_ response: URLResponse, withData data: Data) throws {
        if let httpResponse = response as? HTTPURLResponse {
            switch(httpResponse.statusCode) {
            case 200..<300: debugPrint("sick")
            default: debugPrint("Response Code: \(httpResponse.statusCode)")
                do {
                    let decodedResponse: GenericErrorResponse = try jsonService.decode(data)
                    debugPrint(decodedResponse.getErrors())
                } catch let error as DecodingError {
                    debugPrint(error.localizedDescription)
                    debugPrint(data)
                }
            }
        }
    }
}

// MARK: ProfileInteractor
extension DataSource: ProfileInteractor {
    func fetchCurrentUser() async throws -> User {
        let req = URLRequest(url: userEndpoint, method: .get)
        let (data, res) = try await httpService.send(req)
        try handleBadResponse(res, withData: data)
        let decodedResponse: UserResponse = try jsonService.decode(data)
        return decodedResponse.user
    }
    
    func updateUser(with params: UpdateUserParams) async throws -> User {
        let body = UpdateUserRequest(user: params)
        var req = URLRequest(url: userEndpoint, method: .put)
        req.httpBody = try jsonService.encode(body)
        let (data, res) = try await httpService.send(req)
        try handleBadResponse(res, withData: data)
        let decodedResponse: UserResponse = try jsonService.decode(data)
        return decodedResponse.user
    }
    
    func fetchProfile(with username: String) async throws -> Profile {
        let url = profilesEndpoint.appendingPathComponent(username)
        let req = URLRequest(url: url, method: .get)
        let (data, res) = try await httpService.send(req)
        try handleBadResponse(res, withData: data)
        let decodedResponse: ProfileResponse = try jsonService.decode(data)
        return decodedResponse.profile
    }
    
    func followProfile(with username: String) async throws -> Profile {
        let url = profilesEndpoint.appendingPathComponent(username + "/follow")
        let req = URLRequest(url: url, method: .post)
        let (data, res) = try await httpService.send(req)
        try handleBadResponse(res, withData: data)
        let decodedResponse: ProfileResponse = try jsonService.decode(data)
        return decodedResponse.profile
    }
    
    func unfollowProfile(with username: String) async throws -> Profile {
        let url = profilesEndpoint.appendingPathComponent(username + "/follow")
        let req = URLRequest(url: url, method: .delete)
        let (data, res) = try await httpService.send(req)
        try handleBadResponse(res, withData: data)
        let decodedResponse: ProfileResponse = try jsonService.decode(data)
        return decodedResponse.profile
    }
}

// MARK: ArticleInteractor
extension DataSource: ArticleInteractor {
    // MARK: FEED
    func fetchUserFeed(with params: UserFeedParams) async throws -> [Article] {
        let url = articlesEndpoint.appendingPathComponent("feed")
        var urlWithParams = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlWithParams.queryItems = (try params.dictionary()).map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
        let req = URLRequest(url: urlWithParams.url!, method: .get)
        let (data, res) = try await httpService.send(req)
        try handleBadResponse(res, withData: data)
        let decodedResponse: MultipleArticlesResponse = try jsonService.decode(data)
        return decodedResponse.articles
    }
    
    func fetchGlobalFeed(with params: GlobalFeedParams) async throws -> [Article] {
        var urlWithParams = URLComponents(url: articlesEndpoint, resolvingAgainstBaseURL: true)!
        urlWithParams.queryItems = (try params.dictionary()).map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
        let req = URLRequest(url: urlWithParams.url!, method: .get)
        let (data, res) = try await httpService.send(req)
        try handleBadResponse(res, withData: data)
        let decodedResponse: MultipleArticlesResponse = try jsonService.decode(data)
        return decodedResponse.articles
    }
    
    // MARK: ARTICLE
    func createArticle(withParams params: CreateArticleParams) async throws -> Article {
        var req = URLRequest(url: articlesEndpoint, method: .post)
        let body = CreateArticleRequest(article: params)
        req.httpBody = try jsonService.encode(body)
        let (data, res) = try await httpService.send(req)
        try handleBadResponse(res, withData: data)
        let decodedResponse: SingleArticleResponse = try jsonService.decode(data)
        return decodedResponse.article
    }
    
    func fetchArticle(viaSlug slug: String) async throws -> Article {
        let url = articlesEndpoint.appendingPathComponent(slug)
        let req = URLRequest(url: url, method: .get)
        let (data, res) = try await httpService.send(req)
        try handleBadResponse(res, withData: data)
        let decodedResponse: SingleArticleResponse = try jsonService.decode(data)
        return decodedResponse.article
    }
    
    func updateArticle(viaSlug slug: String, withParams params: UpdateArticleParams) async throws -> Article {
        let url = articlesEndpoint.appendingPathComponent(slug)
        var req = URLRequest(url: url, method: .put)
        let body = UpdateArticleRequest(article: params)
        req.httpBody = try jsonService.encode(body)
        let (data, res) = try await httpService.send(req)
        try handleBadResponse(res, withData: data)
        let decodedResponse: SingleArticleResponse = try jsonService.decode(data)
        return decodedResponse.article
    }
    
    func deleteArticle(viaSlug slug: String) async throws {
        let url = articlesEndpoint.appendingPathComponent(slug)
        let req = URLRequest(url: url, method: .delete)
        let (data, res) = try await httpService.send(req)
        try handleBadResponse(res, withData: data)
    }
    
    // MARK: COMMENTS
    func fetchComments(ofArticleWithSlug slug: String) async throws -> [Comment] {
        let url = articlesEndpoint.appendingPathComponent(slug + "/comments")
        let req = URLRequest(url: url, method: .get)
        let (data, res) = try await httpService.send(req)
        try handleBadResponse(res, withData: data)
        let decodedResponse: MultipleCommentsResponse = try jsonService.decode(data)
        return decodedResponse.comments
    }
    
    func createComment(onArticleWithSlug slug: String, body: String) async throws -> Comment {
        let url = articlesEndpoint.appendingPathComponent(slug + "/comments")
        var req = URLRequest(url: url, method: .post)
        let body = NewCommentRequest(withBody: body)
        req.httpBody = try jsonService.encode(body)
        let (data, res) = try await httpService.send(req)
        try handleBadResponse(res, withData: data)
        let decodedResponse: SingleCommentResponse = try jsonService.decode(data)
        return decodedResponse.comment
    }
    
    func deleteComment(withId id: Int, onArticleWithSlug slug: String) async throws {
        let url = articlesEndpoint.appendingPathComponent( "\(slug)/comments/\(id)")
        let req = URLRequest(url: url, method: .delete)
        let (data, res) = try await httpService.send(req)
        try handleBadResponse(res, withData: data)
    }
    
    // MARK: FAVORITE
    func favoriteArticle(withSlug slug: String) async throws -> Article {
        let url = articlesEndpoint.appendingPathComponent( "\(slug)/favorite")
        let req = URLRequest(url: url, method: .post)
        let (data, res) = try await httpService.send(req)
        try handleBadResponse(res, withData: data)
        let decodedResponse: SingleArticleResponse = try jsonService.decode(data)
        return decodedResponse.article
    }
    
    func unfavoriteArticle(withSlug slug: String) async throws -> Article {
        let url = articlesEndpoint.appendingPathComponent( "\(slug)/favorite")
        let req = URLRequest(url: url, method: .delete)
        let (data, res) = try await httpService.send(req)
        try handleBadResponse(res, withData: data)
        let decodedResponse: SingleArticleResponse = try jsonService.decode(data)
        return decodedResponse.article
    }
    
    // MARK: TAGS
    func fetchTags() async throws -> [String] {
        let req = URLRequest(url: tagsEndpoint, method: .get)
        let (data, res) = try await httpService.send(req)
        try handleBadResponse(res, withData: data)
        let decodedResponse: TagResponse = try jsonService.decode(data)
        return decodedResponse.tags
    }
}
