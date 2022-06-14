//
//  LoginPresenter.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 28/05/22.
//

@MainActor protocol AuthPresenter {
    var authView: AuthView? { get set }
    
    func validate(username: String)
    func validate(email: String)
    func validate(password: String)
    func login(email: String, password: String)
    func register(username: String, email: String, password: String)
}
