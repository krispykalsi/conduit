//
//  ArticleViewController.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 20/05/22.
//

import UIKit

class ArticleViewController: UIViewController {
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var authorImageView: CircularAvatarImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleBodyTextView: UITextView!

    var article: Article!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.label
        populateArticleValues()
    }
    
    private func populateArticleValues() {
        authorNameLabel.text = article.author.username
        authorImageView.loadImage(fromUrl: article.author.image)
        dateCreatedLabel.text = DateFormatter.localizedString(from: article.createdAt,
                                                              dateStyle: .medium,
                                                              timeStyle: .short)
        articleTitleLabel.text = article.title
        articleBodyTextView.text = article.body
    }
    
    @IBAction func onProfileTapped(_ sender: UITapGestureRecognizer) {
        Router.shared.navigate(from: self, to: .profileView(article.author))
    }
    
    @IBAction func onFollowPressed(_ sender: UIButton) {
        
    }
}
