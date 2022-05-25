//
//  auth_interactor.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

protocol AuthInteractor {
    var username: String? { get }
    var authToken: String? { get }
    
    func login(withEmail user: LoginViaEmailParams) async throws -> User
    func register(withEmail user: RegisterViaEmailParams) async throws -> User
    func logout() async throws
}

struct LoginViaEmailParams: Encodable {
    var email: String
    var password: String
}

struct RegisterViaEmailParams: Encodable {
    var username: String
    var email: String
    var password: String
}
