//
//  FeedViewController.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 19/05/22.
//

import UIKit

class FeedViewController: UIViewController {
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var articleTableView: UITableView!
    
    private var presenter = HomeModel.shared
    
    private var tags: [String] = []
    private var articles: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTagCollectionView()
        setupArticleTableView()
        setupHomePresenter()
    }
    
    private func setupTagCollectionView() {
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        let nibName = String(describing: UIMaterialChip.self)
        tagCollectionView.register(UINib(nibName: nibName, bundle: nil),
                                   forCellWithReuseIdentifier: UIMaterialChip.reuseIdentifier)
    }
    
    private func setupArticleTableView() {
        articleTableView.delegate = self
        articleTableView.dataSource = self
        let nibName = String(describing: ArticleTableViewCell.self)
        articleTableView.register(UINib(nibName: nibName, bundle: nil),
                                  forCellReuseIdentifier: ArticleTableViewCell.reuseIdentifier)
    }
    
    private func setupHomePresenter() {
        presenter.view = self
        presenter.loadDataForHomeView()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch (identifier) {
        case Segues.feedToArticle:
            let article = sender as! Article
            let vc = segue.destination as! ArticleViewController
            vc.selectedArticle = article
        default: break
        }
    }
}

extension FeedViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let chip = collectionView.dequeueReusableCell(withReuseIdentifier: UIMaterialChip.reuseIdentifier,
                                                      for: indexPath) as! UIMaterialChip
        chip.label.text = tags[indexPath.row]
        return chip
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let labelWidth = tags[indexPath.row].size(withAttributes: [.font: UIMaterialChip.labelFont]).width
        return CGSize(width: labelWidth + 40, height: 40)
    }
}

extension FeedViewController: HomeView {
    func presenterEvent(onTagsStateChange state: DataState<[String]>) {
        switch(state) {
        case .error(_): debugPrint("couldn't load tags")
        case .loaded(let newTags):
            tags = newTags
            DispatchQueue.main.async {
                self.tagCollectionView.reloadData()
            }
        case .loading: debugPrint("loading tags")
        }
    }
    
    func presenterEvent(onArticlesStateChange state: DataState<[Article]>) {
        switch(state) {
        case .error(_): debugPrint("couldn't load articles")
        case .loaded(let newArticles):
            articles = newArticles
            DispatchQueue.main.async {
                self.articleTableView.reloadData()
            }
        case .loading: debugPrint("loading articles")
        }
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.reuseIdentifier,
                                                 for: indexPath) as! ArticleTableViewCell
        let article = articles[indexPath.row]
        cell.authorLabel.text = article.author.username
        cell.titleLabel.text = article.title
        cell.dateCreatedLabel.text = DateFormatter.localizedString(from: article.createdAt,
                                                                   dateStyle: .medium,
                                                                   timeStyle: .short)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segues.feedToArticle, sender: articles[indexPath.row])
    }
}
