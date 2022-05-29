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
    
    private var isUsernameValid = false
    private var isEmailValid = false
    private var isPasswordValid = false
}

extension AuthModel: AuthPresenter {
    func validate(username: String) {
        var errorMsg = ""
        if !username.doesSatisfy(regex: #"^[\w\d.]+$"#) {
            errorMsg = "Can only contain alphabets, digits, '_' or '.'"
        } else if username.doesSatisfy(regex: #"^[._]"#) {
            errorMsg = "Cannot begin with '_' or '.'"
        }
        isUsernameValid = errorMsg.isEmpty
        if isUsernameValid {
            authView?.authPresenter(didProvideValidation: .valid, forUsername: username)
        } else {
            authView?.authPresenter(didProvideValidation: .invalid(errorMsg), forUsername: username)
        }
    }

    func validate(email: String) {
        var errorMsg = ""
        if !email.contains("@") {
            errorMsg = "There is no '@' symbol in email"
        } else if !email.doesSatisfy(regex: #"@[^@\s]+[^.]\.\w+$"#) {
            errorMsg = "There is no valid domain after '@' symbol"
        } else if !email.doesSatisfy(regex: #"^[^@\s]+@[^@\s]+[^.]\.\w+$"#) {
            errorMsg = "Bad email prefix"
        }
        isEmailValid = errorMsg.isEmpty
        if isEmailValid {
            authView?.authPresenter(didProvideValidation: .valid, forEmail: email)
        } else {
            authView?.authPresenter(didProvideValidation: .invalid(errorMsg), forEmail: email)
        }
    }

    func validate(password: String) {
        var errorMsg = ""
        if !password.doesSatisfy(regex: #"[a-z]"#) {
            errorMsg += "Atleast 1 lowercase letter\n"
        }
        if !password.doesSatisfy(regex: #"[A-Z]"#) {
            errorMsg += "Atleast 1 uppercase letter\n"
        }
        if !password.doesSatisfy(regex: #"\d"#) {
            errorMsg += "Atleast 1 digit\n"
        }
        if !password.doesSatisfy(regex: #"\W"#) {
            errorMsg += "Atleast 1 special character\n"
        }
        if !password.doesSatisfy(regex: #"^.{8,}$"#) {
            errorMsg += "More than 8 characters"
        }
        isPasswordValid = errorMsg.isEmpty
        if isPasswordValid {
            authView?.authPresenter(didProvideValidation: .valid, forPassword: password)
        } else {
            authView?.authPresenter(didProvideValidation: .invalid(errorMsg), forPassword: password)
        }
    }

    func login(email: String, password: String) {
        validate(email: email)
        validate(password: password)
        if isEmailValid && isPasswordValid {
            // begin login
        }
    }

    func register(username: String, email: String, password: String) {
        validate(email: email)
        validate(password: password)
        validate(username: username)
        if isUsernameValid && isEmailValid && isPasswordValid {
            // begin register
        }
    }
}
