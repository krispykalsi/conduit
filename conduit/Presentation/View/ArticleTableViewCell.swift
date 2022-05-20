//
//  ArticleTableViewCell.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 19/05/22.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    static let reuseIdentifier = "articleCell"
    static let authorLabelFont = UIFont(name: "Heebo-Regular_Regular", size: 18.0)!
    static let titleLabelFont = UIFont(name: "Heebo-Regular_Bold", size: 24.0)!
    static let dateLabelFont = UIFont(name: "Heebo-Regular_Regular", size: 14.0)!
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
