//
//  AuthService.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 25/05/22.
//

import Foundation


protocol ILocalAuthService {
    var username: String? { get }
    var authToken: String? { get }
    var isUserLoggedIn: Bool { get }
    
    func cacheAuthDetails(of user: User)
    func clearAuthDetailsFromCache()
}

class LocalAuthService: ILocalAuthService {
    private let KEY_USERNAME = "username"
    private let KEY_AUTH_TOKEN = "authToken"
    
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
    
    var isUserLoggedIn: Bool {
        authToken != nil
    }
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        // didSet is not called in the init function :D
        username = userDefaults.string(forKey: KEY_USERNAME)
        authToken = userDefaults.string(forKey: KEY_AUTH_TOKEN)
    }
    
    static let shared: ILocalAuthService = LocalAuthService(userDefaults: .standard)
    
    func cacheAuthDetails(of user: User) {
        authToken = user.token
        username = user.username
    }
    
    func clearAuthDetailsFromCache() {
        authToken = nil
        username = nil
    }
}
