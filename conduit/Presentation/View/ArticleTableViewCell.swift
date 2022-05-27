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
    
    func populateValues(from article: Article, isAuthorVisible: Bool = true) {
        authorStackView.isHidden = !isAuthorVisible
        if isAuthorVisible {
            authorLabel.text = article.author.username
            authorImage.loadImage(fromUrl: article.author.image)
        }
        titleLabel.text = article.title
        dateCreatedLabel.text = DateFormatter.localizedString(from: article.createdAt,
                                                                   dateStyle: .medium,
                                                                   timeStyle: .short)
    }
}
