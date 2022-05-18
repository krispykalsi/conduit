//
//  auth_interactor.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

protocol AuthInteractor {
    func login(withEmail params: LoginViaEmailParams) async -> Result<User, Error>
    func register(withEmail params: RegisterViaEmailParams) async -> Result<User, Error>
}

struct LoginViaEmailParams: Encodable {
    let email: String
    let password: String
}

struct RegisterViaEmailParams: Encodable {
    let username: String
    let email: String
    let password: String
}
