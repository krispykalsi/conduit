//
//  ProfileViewController.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 23/05/22.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var userImageView: CircularImageView!
    @IBOutlet weak var articlesSegmentControl: UISegmentedControl!
    @IBOutlet weak var userDetailPagesScrollView: UIScrollView!
    @IBOutlet weak var userArticlesTableView: UITableView!
    @IBOutlet weak var favoriteArticlesTableView: UITableView!
    
    private let presenter = ProfileModel.shared
    
    var profile: Profile!
    var isOwnProfile = true
    
    private let userArticlesManager = ArticlesManager(showAuthorDetails: false)
    private let favoriteArticlesManager = ArticlesManager(showAuthorDetails: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupArticleManager()
        setupArticleViews()
        setupPresenter()
    }
    
    private func setupArticleManager() {
        userArticlesManager.parentViewController = self
        favoriteArticlesManager.parentViewController = self
    }
    
    private func setupArticleViews() {
        userDetailPagesScrollView.delegate = self
        userArticlesTableView.delegate = userArticlesManager
        userArticlesTableView.dataSource = userArticlesManager
        favoriteArticlesTableView.delegate = favoriteArticlesManager
        favoriteArticlesTableView.dataSource = favoriteArticlesManager
        let nibName = String(describing: ArticleTableViewCell.self)
        let nib = UINib(nibName: nibName, bundle: nil)
        let identifier = ArticleTableViewCell.reuseIdentifier
        userArticlesTableView.register(nib, forCellReuseIdentifier: identifier)
        favoriteArticlesTableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    private func setupPresenter() {
        presenter.profileView = self
        if isOwnProfile {
            presenter.fetchCurrentUserProfileData()
        } else {
            populateValues(of: profile)
            presenter.fetchArticleData(for: profile.username)
        }
    }
    
    private func populateValues(of profile: Profile) {
        nameLabel.text = profile.username
        bioTextView.text = profile.bio
        userImageView.loadImage(fromUrl: profile.image)
    }
}

extension ProfileViewController: UIScrollViewDelegate {
    @IBAction func onArticleSegmentChanged(_ sender: UISegmentedControl) {
        let i = CGFloat(sender.selectedSegmentIndex)
        let offset = CGPoint(x: userDetailPagesScrollView.bounds.width * i, y: 0)
        userDetailPagesScrollView.setContentOffset(offset, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let i = scrollView.contentOffset.x / scrollView.bounds.width
        articlesSegmentControl.selectedSegmentIndex = Int(i.rounded(.toNearestOrAwayFromZero))
    }
}

extension ProfileViewController: ProfileView {
    func profilePresenter(didUpdateStateOf data: ProfileViewData) {
        switch(data) {
        case .profile(let s):
            handleProfileDataState(s)
        case .userArticles(let s):
            handleUserArticlesDataState(s)
        case .favoriteArticles(let s):
            handleFavoriteArticlesDataState(s)
        }
    }
    
    func profilePresenterRequiresAuth() {
        debugPrint("bro login karle")
    }
    
    private func handleProfileDataState(_ state: DataState<Profile>) {
        if case .loaded(let profile) = state {
            populateValues(of: profile)
        }
    }
    
    private func handleUserArticlesDataState(_ state: DataState<[Article]>) {
        if case .loaded(let articles) = state {
            userArticlesManager.update(articles)
            userArticlesTableView.reloadData()
        }
    }
    
    private func handleFavoriteArticlesDataState(_ state: DataState<[Article]>) {
        if case .loaded(let articles) = state {
            favoriteArticlesManager.update(articles)
            favoriteArticlesTableView.reloadData()
        }
    }
}

fileprivate class ArticlesManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    private var articles: [Article] = []
    private let showAuthorDetails: Bool
    
    weak var parentViewController: UIViewController?
    
    init(showAuthorDetails: Bool) {
        self.showAuthorDetails = showAuthorDetails
    }
    
    func update(_ articles: [Article]) {
        self.articles = articles
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.reuseIdentifier, for: indexPath) as! ArticleTableViewCell
        let article = articles[indexPath.row]
        cell.populateValues(from: article, isAuthorVisible: showAuthorDetails)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Router.shared.navigate(from: parentViewController!, to: .articleView(articles[indexPath.row]))
    }
}
