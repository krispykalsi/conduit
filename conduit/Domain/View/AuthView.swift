//
//  AuthView.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 28/05/22.
//

@MainActor protocol AuthView: AnyObject {
    func authPresenter(didProvideValidation state: ValidationState, forUsername username: String)
    func authPresenter(didProvideValidation state: ValidationState, forEmail email: String)
    func authPresenter(didProvideValidation state: ValidationState, forPassword password: String)
    func authPresenter(didUpdateLoginOrRegisterState state: TaskState)
}
