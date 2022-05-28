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
        let nibName = String(describing: TagCollectionViewCell.self)
        tagCollectionView.register(UINib(nibName: nibName, bundle: nil),
                                   forCellWithReuseIdentifier: TagCollectionViewCell.reuseIdentifier)
    }
    
    private func setupArticleTableView() {
        articleTableView.delegate = self
        articleTableView.dataSource = self
        let nibName = String(describing: ArticleTableViewCell.self)
        articleTableView.register(UINib(nibName: nibName, bundle: nil),
                                  forCellReuseIdentifier: ArticleTableViewCell.reuseIdentifier)
    }
    
    private func setupHomePresenter() {
        presenter.feedView = self
        presenter.loadGlobalFeed()
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
        let chip = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.reuseIdentifier,
                                                      for: indexPath) as! TagCollectionViewCell
        chip.label.text = tags[indexPath.row]
        return chip
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let labelWidth = tags[indexPath.row].size(withAttributes: [.font: TagCollectionViewCell.labelFont]).width
        return CGSize(width: labelWidth + 40, height: 40)
    }
}

extension FeedViewController: FeedView {
    func feedPresenter(didUpdateStateOf data: FeedViewData) {
        switch(data) {
        case .tags(let s):
            handleTagsDataState(s)
        case .articles(let s):
            handleArticlesDataState(s)
        }
    }
    
    private func handleTagsDataState(_ state: DataState<[String]>) {
        switch(state) {
        case .error(_): debugPrint("couldn't load tags")
        case .loaded(let newTags):
            tags = newTags
            self.tagCollectionView.reloadData()
        case .loading: debugPrint("loading tags")
        }
    }
    
    private func handleArticlesDataState(_ state: DataState<[Article]>) {
        switch(state) {
        case .error(_): debugPrint("couldn't load articles")
        case .loaded(let newArticles):
            articles = newArticles
            self.articleTableView.reloadData()
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
        cell.populateValues(from: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Router.shared.navigate(from: self, to: .articleView(articles[indexPath.row]))
    }
}
