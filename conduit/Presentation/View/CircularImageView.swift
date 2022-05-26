//
//  CircularImageView.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 20/05/22.
//

import UIKit

@IBDesignable
class CircularImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = layer.frame.height / 2
        clipsToBounds = true
    }
}
