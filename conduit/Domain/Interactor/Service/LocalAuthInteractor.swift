//
//  auth_interactor.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

protocol LocalAuthInteractor {
    var username: String? { get }
    var authToken: String? { get }
    var isLoggedIn: Bool { get }
    
    func cacheAuthDetails(of user: User)
    func clearAuthDetailsFromCache()
}
