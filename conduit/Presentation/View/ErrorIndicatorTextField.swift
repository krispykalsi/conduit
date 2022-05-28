//
//  ErrorIndicatorTextField.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 28/05/22.
//

import UIKit

@IBDesignable
class ErrorIndicatorTextField: UIView, NIBLoadable {
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNIB()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromNIB()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.layer.cornerRadius = 8
    }
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    private let animDuration = 0.3
    
    weak var delegate: ErrorIndicatorTextFieldDelegate?
    
    @IBAction func didChangeText() {
        delegate?.errorIndicatorTextFieldDidChange(self)
    }
    
    @IBAction func editingDidEnd() {
        delegate?.errorIndicatorTextFieldDidEndEditing(self)
    }
}

extension ErrorIndicatorTextField {
    @IBInspectable var placeholder: String? {
        get { return textField.placeholder }
        set { textField.placeholder = newValue }
    }
    
    var contentType: UITextContentType {
        get { textField.textContentType }
        set {
            textField.textContentType = newValue
            textField.isSecureTextEntry = newValue == .password
        }
    }
    
    var hasText: Bool {
        get { textField.hasText }
    }
    
    var text: String {
        get { textField.text ?? "" }
        set { textField.text = newValue }
    }
}

extension ErrorIndicatorTextField {
    func indicateError(message: String) {
        UIView.animate(withDuration: animDuration) { [unowned self] in
            errorLabel.text = message
            errorView.isHidden = false
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor.systemRed.cgColor
        }
    }
    
    func indicateCorrect() {
        UIView.animate(withDuration: animDuration) { [unowned self] in
            errorView.isHidden = true
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor.systemGreen.cgColor
        }
    }
    
    func resetToNormalState() {
        UIView.animate(withDuration: animDuration) { [unowned self] in
            errorView.isHidden = true
            textField.layer.borderWidth = 0
            textField.layer.borderColor = nil
        }
    }
}

protocol ErrorIndicatorTextFieldDelegate: AnyObject {
    func errorIndicatorTextFieldDidChange(_ textField: ErrorIndicatorTextField)
    func errorIndicatorTextFieldDidEndEditing(_ textField: ErrorIndicatorTextField)
}
