//
//  auth_interactor.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

protocol AuthInteractor {
    func login(withEmail user: LoginViaEmailParams) async -> Result<User, Error>
    func register(withEmail user: RegisterViaEmailParams) async -> Result<User, Error>
}

struct LoginViaEmailParams: Codable {
    let email: String
    let password: String
}

struct RegisterViaEmailParams: Codable {
    let username: String
    let email: String
    let password: String
}
