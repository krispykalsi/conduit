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
    
    private let urlSession: URLSession
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    private let userDefaults: UserDefaults
    
    init(urlSession: URLSession, jsonEncoder: JSONEncoder, jsonDecoder: JSONDecoder, userDefaults: UserDefaults) {
        self.urlSession = urlSession
        self.jsonEncoder = jsonEncoder
        self.jsonDecoder = jsonDecoder
        self.userDefaults = userDefaults
        // didSet is not called in the init function :D
        username = userDefaults.string(forKey: KEY_USERNAME)
        authToken = userDefaults.string(forKey: KEY_AUTH_TOKEN)
    }
    
    private func handleBadResponse(_ response: URLResponse, withData data: Data) throws {
        if let httpResponse = response as? HTTPURLResponse {
            switch(httpResponse.statusCode) {
            case 200..<300: debugPrint("sick")
            default: debugPrint("Response Code: \(httpResponse.statusCode)")
                do {
                    let decodedResponse = try jsonDecoder.decode(GenericErrorResponse.self, from: data)
                    debugPrint(decodedResponse.getErrors())
                } catch let error as DecodingError {
                    debugPrint(error.localizedDescription)
                    debugPrint(data)
                }
            }
        }
    }
}

extension AuthService: AuthInteractor {
    func login(withEmail user: LoginViaEmailParams) async throws -> User {
        let url = AUTH_ENDPOINT.appendingPathComponent("login")
        let body = LoginUserRequest(user: user)
        var req = URLRequest(url: url, method: .post)
        req.httpBody = try jsonEncoder.encode(body)
        let (data, res) = try await urlSession.data(for: req)
        try handleBadResponse(res, withData: data)
        let decodedResponse = try jsonDecoder.decode(UserResponse.self, from: data)
        return decodedResponse.user
    }
    
    func register(withEmail user: RegisterViaEmailParams) async throws -> User {
        let body = RegisterUserRequest(user: user)
        var req = URLRequest(url: AUTH_ENDPOINT, method: .post)
        req.httpBody = try jsonEncoder.encode(body)
        let (data, res) = try await urlSession.data(for: req)
        try handleBadResponse(res, withData: data)
        let decodedResponse = try jsonDecoder.decode(UserResponse.self, from: data)
        return decodedResponse.user
    }
    
    func logout() async throws {
        userDefaults.setNilValueForKey(KEY_AUTH_TOKEN)
    }
}
