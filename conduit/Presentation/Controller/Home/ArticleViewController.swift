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
    @IBOutlet weak var authorImageView: CircularImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleBodyTextView: UITextView!
        
    var article: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.label
        populateArticleValues()
    }
    
    func populateArticleValues() {
        guard let article = article else { return }
        authorNameLabel.text = article.author.username
        dateCreatedLabel.text = DateFormatter.localizedString(from: article.createdAt, dateStyle: .medium, timeStyle: .none)
        articleTitleLabel.text = article.title
        articleBodyTextView.text = article.body
    }
    
    @IBAction func onProfileTapped(_ sender: UITapGestureRecognizer) {
        guard let article = article else { return }
        performSegue(withIdentifier: getSegue(.articleToProfile), sender: article.author.username)
    }
    
    @IBAction func onFollowPressed(_ sender: UIButton) {
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(NavigationSegue(rawValue: segue.identifier ?? "")) {
        case .articleToProfile:
            let name = sender as! String
            let vc = segue.destination as! ProfileViewController
            vc.username = name
        default: break
        }
    }
}
