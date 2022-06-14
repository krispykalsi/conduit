//
//  LoginModel.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 28/05/22.
//

class AuthModel {
    internal init(userRepository: IUserRepository) {
        self.userRepository = userRepository
    }
    
    private let userRepository: IUserRepository
    weak var authView: AuthView?
    
    static let shared = AuthModel(userRepository: ConduitAPI.shared)
    
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
        guard !email.isEmpty else {
            authView?.authPresenter(didProvideValidation: .invalid("Can't be empty"),
                                    forEmail: email)
            return
        }
        guard !password.isEmpty else {
            authView?.authPresenter(didProvideValidation: .invalid("Can't be empty"),
                                    forPassword: password)
            return
        }
        authView?.authPresenter(didUpdateLoginOrRegisterState: .inProgress)
        Task {
            do {
                let params = LoginViaEmailParams(email: email, password: password)
                _ = try await userRepository.login(withEmail: params)
                authView?.authPresenter(didUpdateLoginOrRegisterState: .success)
            } catch let err as APIError {
                handle(apiError: err)
            } catch {
                authView?.authPresenter(didUpdateLoginOrRegisterState: .failure(error.localizedDescription))
            }
        }
    }

    func register(username: String, email: String, password: String) {
        validate(email: email)
        validate(password: password)
        validate(username: username)
        if isUsernameValid && isEmailValid && isPasswordValid {
            authView?.authPresenter(didUpdateLoginOrRegisterState: .inProgress)
            Task {
                do {
                    let params = RegisterViaEmailParams(username: username, email: email, password: password)
                    _ = try await userRepository.register(withEmail: params)
                    authView?.authPresenter(didUpdateLoginOrRegisterState: .success)
                } catch let err as APIError {
                    handle(apiError: err)
                } catch {
                    authView?.authPresenter(didUpdateLoginOrRegisterState: .failure(error.localizedDescription))
                }
            }
        }
    }
    
    @MainActor private func handle(apiError: APIError) {
        switch(apiError) {
        case .non200Response(code: _, msg: let msg):
            authView?.authPresenter(didUpdateLoginOrRegisterState: .failure(msg))
        case .fromBackend(errors: let errors):
            authView?.authPresenter(didUpdateLoginOrRegisterState: .failure("\(errors)"))
        case .unknown(msg: let msg):
            authView?.authPresenter(didUpdateLoginOrRegisterState: .failure(msg))
        }
    }
}
