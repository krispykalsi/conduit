//
//  NIBLoadable.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 28/05/22.
//

import UIKit

public protocol NIBLoadable {
    static var nibName: String { get }
}

public extension NIBLoadable where Self: UIView {
    static var nibName: String {
        return String(describing: Self.self)
    }

    static var nib: UINib {
        let bundle = Bundle(for: Self.self)
        return UINib(nibName: Self.nibName, bundle: bundle)
    }

    func loadFromNIB() {
        guard let view = Self.nib.instantiate(withOwner: self, options: nil).first as? UIView else { fatalError("Error loading \(self) from nib") }
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0),
            view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
}
