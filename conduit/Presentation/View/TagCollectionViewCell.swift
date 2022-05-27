//
//  TagCollectionViewCell.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 19/05/22.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "tagCell"
    static let labelFont = UIFont(name: "Heebo-Regular", size: 18.0)!
    private let cornerRadius = 20.0
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.font = TagCollectionViewCell.labelFont
        // Apply rounded corners to contentView
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true

        // Set masks to bounds to false to avoid the shadow
        // from being clipped to the corner radius
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
//
//        // Apply a shadow
//        layer.shadowRadius = 8.0
//        layer.shadowOpacity = 0.10
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
}
