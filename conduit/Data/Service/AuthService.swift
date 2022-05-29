//
//  AuthService.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 25/05/22.
//

import Foundation

class AuthService {
    private let KEY_USERNAME = "username"
    private let KEY_AUTH_TOKEN = "authToken"
    private let AUTH_ENDPOINT = URL(string: "https://api.realworld.io/api/users")!
    
    private (set) var username: String? {
        didSet {
            userDefaults.set(username, forKey: KEY_USERNAME)
        }
    }
    
    private (set) var authToken: String? {
        didSet {
            userDefaults.set(authToken, forKey: KEY_AUTH_TOKEN)
        }
    }
    
    var isLoggedIn: Bool {
        authToken != nil
    }
    
    private let urlSession: URLSession
    private let jsonService: JSONService
    private let userDefaults: UserDefaults
    
    init(urlSession: URLSession, jsonService: JSONService, userDefaults: UserDefaults) {
        self.urlSession = urlSession
        self.jsonService = jsonService
        self.userDefaults = userDefaults
        // didSet is not called in the init function :D
        username = userDefaults.string(forKey: KEY_USERNAME)
        authToken = userDefaults.string(forKey: KEY_AUTH_TOKEN)
    }
    
    static let shared: AuthInteractor = AuthService(urlSession: .shared,
                                                    jsonService: JSONParser.shared,
                                                    userDefaults: .standard)
    
    private func throwForBadResponse(_ response: URLResponse, _ data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown(msg: "Response is not HTTP? \n \(response.description)")
        }
        if 200 ..< 300 ~= httpResponse.statusCode {
            return
        }
        do {
            let decodedResponse: GenericErrorResponse = try jsonService.decode(data)
            throw APIError.fromBackend(errors: decodedResponse.getErrors())
        } catch let error as DecodingError {
            debugPrint(error)
            throw APIError.non200Response(code: httpResponse.statusCode,
                                          msg: httpResponse.description)
        }
    }
}

extension AuthService: AuthInteractor {
    func login(withEmail user: LoginViaEmailParams) async throws -> User {
        let url = AUTH_ENDPOINT.appendingPathComponent("login")
        let body = LoginUserRequest(user: user)
        var req = URLRequest(url: url, method: .post)
        req.httpBody = try jsonService.encode(body)
        let (data, res) = try await urlSession.data(for: req)
        try throwForBadResponse(res, data)
        let decodedResponse: UserResponse = try jsonService.decode(data)
        cacheAuthDetails(for: decodedResponse.user)
        return decodedResponse.user
    }
    
    func register(withEmail user: RegisterViaEmailParams) async throws -> User {
        let body = RegisterUserRequest(user: user)
        var req = URLRequest(url: AUTH_ENDPOINT, method: .post)
        req.httpBody = try jsonService.encode(body)
        let (data, res) = try await urlSession.data(for: req)
        try throwForBadResponse(res, data)
        let decodedResponse: UserResponse = try jsonService.decode(data)
        cacheAuthDetails(for: decodedResponse.user)
        return decodedResponse.user
    }
    
    private func cacheAuthDetails(for user: User) {
        self.authToken = user.token
        self.username = user.username
    }
    
    func logout() async throws {
        authToken = nil
    }
}
