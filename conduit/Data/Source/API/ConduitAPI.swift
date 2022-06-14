//
//  ConduitAPIDataSource.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 25/05/22.
//

import Foundation

class ConduitAPI: IArticleRepository, IProfileRepository, IUserRepository {
    private static let baseUrl = URL(string: "https://api.realworld.io/api")!
    private let userEndpoint = baseUrl.appendingPathComponent("user")
    private let usersEndpoint = baseUrl.appendingPathComponent("users")
    private let articlesEndpoint = baseUrl.appendingPathComponent("articles")
    private let profilesEndpoint = baseUrl.appendingPathComponent("profiles")
    private let tagsEndpoint = baseUrl.appendingPathComponent("tags")
    
    private let localAuthService: ILocalAuthService
    private let httpService: IHTTPService
    private let jsonService: IJSONService
    
    internal init(localAuthService: ILocalAuthService,
                  httpService: IHTTPService,
                  jsonService: IJSONService) {
        self.localAuthService = localAuthService
        self.httpService = httpService
        self.jsonService = jsonService
    }
    
    static let shared = ConduitAPI(localAuthService: LocalAuthService.shared,
                                   httpService: HTTPService.shared,
                                   jsonService: JSONService.shared)
    
    private func throwForBadResponse(_ response: URLResponse, _ data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown(msg: "Response is not HTTP? \n \(response.description)")
        }
        if 200 ..< 300 ~= httpResponse.statusCode {
            return
        }
        do {
            let decodedResponse: GenericErrorResponse = try jsonService.decode(data)
            throw APIError.fromBackend(errors: decodedResponse.errors)
        } catch let error as DecodingError {
            debugPrint(error)
            throw APIError.non200Response(code: httpResponse.statusCode,
                                          msg: httpResponse.description)
        }
    }
}

// MARK: - IProfileRepository
extension ConduitAPI {
    func fetchProfile(with username: String) async throws -> Profile {
        let url = profilesEndpoint.appendingPathComponent(username)
        var req = URLRequest(url: url, method: .get)
        let (data, res) = try await httpService.send(&req)
        try throwForBadResponse(res, data)
        let decodedResponse: ProfileResponse = try jsonService.decode(data)
        return decodedResponse.profile
    }
    
    func followProfile(with username: String) async throws -> Profile {
        let url = profilesEndpoint.appendingPathComponent(username + "/follow")
        var req = URLRequest(url: url, method: .post)
        let (data, res) = try await httpService.send(&req)
        try throwForBadResponse(res, data)
        let decodedResponse: ProfileResponse = try jsonService.decode(data)
        return decodedResponse.profile
    }
    
    func unfollowProfile(with username: String) async throws -> Profile {
        let url = profilesEndpoint.appendingPathComponent(username + "/follow")
        var req = URLRequest(url: url, method: .delete)
        let (data, res) = try await httpService.send(&req)
        try throwForBadResponse(res, data)
        let decodedResponse: ProfileResponse = try jsonService.decode(data)
        return decodedResponse.profile
    }
}

// MARK: - IArticleRepository
extension ConduitAPI {
    // MARK: FEED
    func fetchUserFeed(with params: UserFeedParams) async throws -> [Article] {
        let url = articlesEndpoint.appendingPathComponent("feed")
        var urlWithParams = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlWithParams.queryItems = (try params.dictionary()).map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
        var req = URLRequest(url: urlWithParams.url!, method: .get)
        let (data, res) = try await httpService.send(&req)
        try throwForBadResponse(res, data)
        let decodedResponse: MultipleArticlesResponse = try jsonService.decode(data)
        return decodedResponse.articles
    }
    
    func fetchGlobalFeed(with params: GlobalFeedParams) async throws -> [Article] {
        var urlWithParams = URLComponents(url: articlesEndpoint, resolvingAgainstBaseURL: true)!
        urlWithParams.queryItems = (try params.dictionary()).map { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
        var req = URLRequest(url: urlWithParams.url!, method: .get)
        let (data, res) = try await httpService.send(&req)
        try throwForBadResponse(res, data)
        let decodedResponse: MultipleArticlesResponse = try jsonService.decode(data)
        return decodedResponse.articles
    }
    
    // MARK: ARTICLE
    func createArticle(withParams params: CreateArticleParams) async throws -> Article {
        var req = URLRequest(url: articlesEndpoint, method: .post)
        let body = CreateArticleRequest(article: params)
        req.httpBody = try jsonService.encode(body)
        let (data, res) = try await httpService.send(&req)
        try throwForBadResponse(res, data)
        let decodedResponse: SingleArticleResponse = try jsonService.decode(data)
        return decodedResponse.article
    }
    
    func fetchArticle(viaSlug slug: String) async throws -> Article {
        let url = articlesEndpoint.appendingPathComponent(slug)
        var req = URLRequest(url: url, method: .get)
        let (data, res) = try await httpService.send(&req)
        try throwForBadResponse(res, data)
        let decodedResponse: SingleArticleResponse = try jsonService.decode(data)
        return decodedResponse.article
    }
    
    func updateArticle(viaSlug slug: String, withParams params: UpdateArticleParams) async throws -> Article {
        let url = articlesEndpoint.appendingPathComponent(slug)
        var req = URLRequest(url: url, method: .put)
        let body = UpdateArticleRequest(article: params)
        req.httpBody = try jsonService.encode(body)
        let (data, res) = try await httpService.send(&req)
        try throwForBadResponse(res, data)
        let decodedResponse: SingleArticleResponse = try jsonService.decode(data)
        return decodedResponse.article
    }
    
    func deleteArticle(viaSlug slug: String) async throws {
        let url = articlesEndpoint.appendingPathComponent(slug)
        var req = URLRequest(url: url, method: .delete)
        let (data, res) = try await httpService.send(&req)
        try throwForBadResponse(res, data)
    }
    
    // MARK: COMMENTS
    func fetchComments(ofArticleWithSlug slug: String) async throws -> [Comment] {
        let url = articlesEndpoint.appendingPathComponent(slug + "/comments")
        var req = URLRequest(url: url, method: .get)
        let (data, res) = try await httpService.send(&req)
        try throwForBadResponse(res, data)
        let decodedResponse: MultipleCommentsResponse = try jsonService.decode(data)
        return decodedResponse.comments
    }
    
    func createComment(onArticleWithSlug slug: String, body: String) async throws -> Comment {
        let url = articlesEndpoint.appendingPathComponent(slug + "/comments")
        var req = URLRequest(url: url, method: .post)
        let body = NewCommentRequest(withBody: body)
        req.httpBody = try jsonService.encode(body)
        let (data, res) = try await httpService.send(&req)
        try throwForBadResponse(res, data)
        let decodedResponse: SingleCommentResponse = try jsonService.decode(data)
        return decodedResponse.comment
    }
    
    func deleteComment(withId id: Int, onArticleWithSlug slug: String) async throws {
        let url = articlesEndpoint.appendingPathComponent( "\(slug)/comments/\(id)")
        var req = URLRequest(url: url, method: .delete)
        let (data, res) = try await httpService.send(&req)
        try throwForBadResponse(res, data)
    }
    
    // MARK: FAVORITE
    func favoriteArticle(withSlug slug: String) async throws -> Article {
        let url = articlesEndpoint.appendingPathComponent( "\(slug)/favorite")
        var req = URLRequest(url: url, method: .post)
        let (data, res) = try await httpService.send(&req)
        try throwForBadResponse(res, data)
        let decodedResponse: SingleArticleResponse = try jsonService.decode(data)
        return decodedResponse.article
    }
    
    func unfavoriteArticle(withSlug slug: String) async throws -> Article {
        let url = articlesEndpoint.appendingPathComponent( "\(slug)/favorite")
        var req = URLRequest(url: url, method: .delete)
        let (data, res) = try await httpService.send(&req)
        try throwForBadResponse(res, data)
        let decodedResponse: SingleArticleResponse = try jsonService.decode(data)
        return decodedResponse.article
    }
    
    // MARK: TAGS
    func fetchTags() async throws -> [String] {
        var req = URLRequest(url: tagsEndpoint, method: .get)
        let (data, res) = try await httpService.send(&req)
        try throwForBadResponse(res, data)
        let decodedResponse: TagResponse = try jsonService.decode(data)
        return decodedResponse.tags
    }
}

// MARK: - IUserRepository
extension ConduitAPI {
    func fetchCurrentUser() async throws -> User {
        var req = URLRequest(url: userEndpoint, method: .get)
        let (data, res) = try await httpService.send(&req)
        try throwForBadResponse(res, data)
        let decodedResponse: UserResponse = try jsonService.decode(data)
        return decodedResponse.user
    }
    
    func updateUser(with params: UpdateUserParams) async throws -> User {
        let body = UpdateUserRequest(user: params)
        var req = URLRequest(url: userEndpoint, method: .put)
        req.httpBody = try jsonService.encode(body)
        let (data, res) = try await httpService.send(&req)
        try throwForBadResponse(res, data)
        let decodedResponse: UserResponse = try jsonService.decode(data)
        return decodedResponse.user
    }

    func login(withEmail user: LoginViaEmailParams) async throws -> User {
        let url = usersEndpoint.appendingPathComponent("login")
        let body = LoginUserRequest(user: user)
        var req = URLRequest(url: url, method: .post)
        req.httpBody = try jsonService.encode(body)
        let (data, res) = try await httpService.send(&req)
        try throwForBadResponse(res, data)
        let decodedResponse: UserResponse = try jsonService.decode(data)
        localAuthService.cacheAuthDetails(of: decodedResponse.user)
        return decodedResponse.user
    }
    
    func register(withEmail user: RegisterViaEmailParams) async throws -> User {
        let body = RegisterUserRequest(user: user)
        var req = URLRequest(url: usersEndpoint, method: .post)
        req.httpBody = try jsonService.encode(body)
        let (data, res) = try await httpService.send(&req)
        try throwForBadResponse(res, data)
        let decodedResponse: UserResponse = try jsonService.decode(data)
        localAuthService.cacheAuthDetails(of: decodedResponse.user)
        return decodedResponse.user
    }
}
