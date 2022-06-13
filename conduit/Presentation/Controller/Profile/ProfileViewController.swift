//
//  ProfileViewController.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 23/05/22.
//

import UIKit

class ProfileViewController: UIViewController, ProfileView {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: CircularAvatarImageView!
    @IBOutlet weak var followButton: FollowButton!
    @IBOutlet weak var editDetailsButton: UIButton!
    @IBOutlet weak var logOutButton: UIBarButtonItem!

    @IBOutlet weak var articlesSegmentControl: UISegmentedControl!
    @IBOutlet weak var userDetailPagesScrollView: UIScrollView!
    @IBOutlet weak var userArticlesTableView: UITableView!
    @IBOutlet weak var favoriteArticlesTableView: UITableView!
    @IBOutlet weak var bioTextView: UITextView!
    
    private let presenter = ProfileModel.shared
    
    var profile: Profile!
    var isOwnProfile = true
    
    private let userArticlesManager = ArticleTableManager(showAuthorDetails: false)
    private let favoriteArticlesManager = ArticleTableManager(showAuthorDetails: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPresenter()
        setupProfileActionButton()
        setupArticleViews()
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
        self.profile = profile
        nameLabel.text = profile.username
        bioTextView.text = profile.bio
        userImageView.loadImage(fromUrl: profile.image)
        if !isOwnProfile && profile.following {
            followButton.changeTo(.unfollow)
        }
    }
    
    private func setupProfileActionButton() {
        editDetailsButton.isHidden = !isOwnProfile
        followButton.isHidden = isOwnProfile
        if !isOwnProfile {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    private func setupArticleViews() {
        userDetailPagesScrollView.delegate = self
        setupArticleTableManager()
        let nibName = String(describing: ArticleTableViewCell.self)
        let nib = UINib(nibName: nibName, bundle: nil)
        let identifier = ArticleTableViewCell.reuseIdentifier
        userArticlesTableView.register(nib, forCellReuseIdentifier: identifier)
        favoriteArticlesTableView.register(nib, forCellReuseIdentifier: identifier)
    }
    
    private func setupArticleTableManager() {
        userArticlesManager.parentViewController = self
        favoriteArticlesManager.parentViewController = self
        userArticlesTableView.delegate = userArticlesManager
        userArticlesTableView.dataSource = userArticlesManager
        favoriteArticlesTableView.delegate = favoriteArticlesManager
        favoriteArticlesTableView.dataSource = favoriteArticlesManager
    }
    
    @IBAction func didTapEditDetailsButton() {
        
    }
    
    @IBAction func didTapFollowButton() {
        if profile.following {
            presenter.unfollowUser(with: profile.username)
        } else {
            presenter.followUser(with: profile.username)
        }
    }
    
    @IBAction func didTapLogOutButton() {
        let alert = UIAlertController(title: "Are you sure?", message: "You will need to enter your details to login again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { _ in
            self.presenter.logOut()
        })
        present(alert, animated: true)
    }
}

// MARK: - Sync logic b/w ScrollView and SegmentControl
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

// MARK: - ProfilePresenter events
extension ProfileViewController {
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
    
    func profilePresenter(didUpdateFollowState state: TaskState) {
        switch(state) {
        case .success:
            followButton.changeTo(.unfollow)
            followButton.isEnabled = true
        case .inProgress:
            followButton.isEnabled = false
        case .failure(_):
            followButton.isEnabled = true
        }
    }
    
    func profilePresenter(didUpdateUnfollowState state: TaskState) {
        switch(state) {
        case .success:
            followButton.changeTo(.follow)
            followButton.isEnabled = true
        case .inProgress:
            followButton.isEnabled = false
        case .failure(_):
            followButton.isEnabled = true
        }
    }
    
    func profilePresenterRequiresAuth() {
        Router.shared.replace(self, with: .loginView)
    }
    
    private func handleProfileDataState(_ state: DataState<Profile>) {
        switch(state) {
        case .loaded(let profile):
            populateValues(of: profile)
            followButton.isEnabled = true
        case .loading:
            followButton.isEnabled = false
        case .error(let msg):
            print(msg)
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

// MARK: - TableView Delegate and DataSource
fileprivate class ArticleTableManager: NSObject, UITableViewDelegate, UITableViewDataSource {
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
