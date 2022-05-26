//
//  ArticleTableViewCell.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 19/05/22.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    static let reuseIdentifier = "articleCell"
    
    @IBOutlet weak var authorStackView: UIStackView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorImage: CircularImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
}
