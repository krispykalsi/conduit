//
//  LoginModel.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 28/05/22.
//

class AuthModel {
    internal init(authInteractor: AuthInteractor) {
        self.authInteractor = authInteractor
    }
    
    private let authInteractor: AuthInteractor
    
    weak var authView: AuthView?
    
    static let shared = AuthModel(authInteractor: AuthService.shared)
}

extension AuthModel: AuthPresenter {
    func validate(username: String) {
        
    }

    func validate(email: String) {
        
    }

    func validate(password: String) {
        
    }

    func login(email: String, password: String) {

    }

    func register(username: String, email: String, password: String) {

    }
}
