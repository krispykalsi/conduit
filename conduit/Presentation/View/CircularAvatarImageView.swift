//
//  CircularImageView.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 20/05/22.
//

import UIKit

@IBDesignable
class CircularAvatarImageView: CachedImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = layer.frame.height / 2
        clipsToBounds = true
        contentMode = .scaleAspectFill
        image = UIImage(systemName: "person.crop.circle.fill")
    }
}
