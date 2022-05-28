//
//  LoginViewController.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 28/05/22.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var changeToLoginOrRegisterButton: UIButton!
    @IBOutlet weak var loginOrRegisterButton: UIButton!
    
    private var isNewUser = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isNewUser ? changeViewToRegister() : changeViewToLogin()
    }
    
    @IBAction func didTapOutsideTextField() {
        view.endEditing(true)
    }
    
    @IBAction func onLoginOrRegisterTapped() {
        
    }
}

extension LoginViewController {
    private func changeViewToRegister() {
        title = "Register"
        usernameField.isHidden = false
        changeToLoginOrRegisterButton.titleLabel?.text = "Have an account? Login here"
        updateLoginOrRegisterButton()
    }
    
    private func changeViewToLogin() {
        title = "Login"
        usernameField.isHidden = true
        changeToLoginOrRegisterButton.titleLabel?.text = "Need an account? Register here"
        updateLoginOrRegisterButton()
    }
    
    private func updateLoginOrRegisterButton() {
        loginOrRegisterButton.setTitle(title, for: .normal)
        loginOrRegisterButton.sizeToFit()
    }
    
    @IBAction func toggleLoginRegister() {
        isNewUser = !isNewUser
        isNewUser ? changeViewToRegister() : changeViewToLogin()
    }
}
