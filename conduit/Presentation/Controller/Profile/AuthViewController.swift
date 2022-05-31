//
//  AuthViewController.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 28/05/22.
//

import UIKit

class AuthViewController: UIViewController {
    @IBOutlet weak var usernameField: ErrorIndicatorTextField!
    @IBOutlet weak var emailField: ErrorIndicatorTextField!
    @IBOutlet weak var passwordField: ErrorIndicatorTextField!
    @IBOutlet weak var changeToLoginOrRegisterViewButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    private var isNewUser = true
    
    private var presenter: AuthPresenter = AuthModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        presenter.authView = self
        submitButton.isEnabled = false
        isNewUser ? changeViewToRegister() : changeViewToLogin()
    }

    private func setupTextFields() {
        usernameField.contentType = .username
        emailField.contentType = .emailAddress
        emailField.textField.autocorrectionType = .no
        passwordField.contentType = .password
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
    }
}

// MARK: - Presenter events and input validation
extension AuthViewController: AuthView, ErrorIndicatorTextFieldDelegate {
    func authPresenter(didProvideValidation state: ValidationState, forUsername username: String) {
        switch(state) {
        case .valid: usernameField.indicateCorrect()
        case .invalid(let msg): usernameField.indicateError(message: msg)
        }
    }

    func authPresenter(didProvideValidation state: ValidationState, forEmail email: String) {
        switch(state) {
        case .valid: emailField.indicateCorrect()
        case .invalid(let msg): emailField.indicateError(message: msg)
        }
    }

    func authPresenter(didProvideValidation state: ValidationState, forPassword password: String) {
        switch(state) {
        case .valid: passwordField.indicateCorrect()
        case .invalid(let msg): passwordField.indicateError(message: msg)
        }
    }

    func authPresenter(didUpdateLoginOrRegisterState state: TaskState) {
        switch(state) {
        case .success:
            Router.shared.replace(self, with: .profileView(nil))
        case .failure(let msg):
            showErrorAlert(with: msg)
        case .inProgress:
            view.isUserInteractionEnabled = false
            return
        }
        view.isUserInteractionEnabled = true
    }
    
    private func showErrorAlert(with msg: String) {
        let task = isNewUser ? "Registration" : "Login"
        let alert = UIAlertController(title: "\(task) Failed", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func didTapOutsideTextField() {
        view.endEditing(true)
    }
    
    func errorIndicatorTextFieldDidChange(_ textField: ErrorIndicatorTextField) {
        updateSubmitButtonState()
    }
    
    private func updateSubmitButtonState() {
        var hasTextInAllFields = true
        hasTextInAllFields = hasTextInAllFields && (!isNewUser || usernameField.hasText)
        hasTextInAllFields = hasTextInAllFields && emailField.hasText
        hasTextInAllFields = hasTextInAllFields && passwordField.hasText
        submitButton.isEnabled = hasTextInAllFields
    }
    
    func errorIndicatorTextFieldDidEndEditing(_ textField: ErrorIndicatorTextField) {
        if !isNewUser {
            return
        }
        switch(textField) {
        case usernameField: presenter.validate(username: textField.text)
        case emailField: presenter.validate(email: textField.text)
        case passwordField: presenter.validate(password: textField.text)
        default: break
        }
    }
    
    @IBAction func onSubmitTapped() {
        if isNewUser {
            presenter.register(username: usernameField.text,
                               email: emailField.text,
                               password: passwordField.text)
        } else {
            presenter.login(email: emailField.text, password: passwordField.text)
        }
    }
}

// MARK: - Switching in Login/Register Views
extension AuthViewController {
    private func changeViewToRegister() {
        title = "Register"
        usernameField.isHidden = false
        changeToLoginOrRegisterViewButton.setTitle("Have an account? Login here", for: .normal)
        submitButton.setTitle(title, for: .normal)
    }
    
    private func changeViewToLogin() {
        title = "Login"
        usernameField.isHidden = true
        changeToLoginOrRegisterViewButton.setTitle("Need an account? Register here", for: .normal)
        submitButton.setTitle(title, for: .normal)
    }

    @IBAction func toggleLoginRegister() {
        isNewUser = !isNewUser
        isNewUser ? changeViewToRegister() : changeViewToLogin()
    }
}
