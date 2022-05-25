//
//  ArticleViewController.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 20/05/22.
//

import UIKit

class ArticleViewController: UIViewController, HomeView {
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var dateCreatedLabel: UILabel!
    @IBOutlet weak var authorImageView: CircularImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleBodyTextView: UITextView!
    
    private var presenter = HomeModel.shared
    
    var selectedArticle: Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.label
        setupHomePresenter()
        populateArticleValues()
    }
    
    func setupHomePresenter() {
        presenter.view = self
    }
    
    func populateArticleValues() {
        guard let article = selectedArticle else { return }
        authorNameLabel.text = article.author.username
        dateCreatedLabel.text = DateFormatter.localizedString(from: article.createdAt, dateStyle: .medium, timeStyle: .none)
        articleTitleLabel.text = article.title
        articleBodyTextView.text = article.body
    }
    
    @IBAction func onProfileTapped(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: Segues.articleToProfile, sender: nil)
    }
    
    @IBAction func onFollowPressed(_ sender: UIButton) {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
