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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTagCollectionView()
        setupArticleTableView()
        setupHomePresenter()
    }
    
    private func setupTagCollectionView() {
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        tagCollectionView.register(UINib(nibName: "UIMaterialChip", bundle: nil),
                                   forCellWithReuseIdentifier: UIMaterialChip.reuseIdentifier)
    }
    
    private func setupArticleTableView() {
        articleTableView.delegate = self
        articleTableView.dataSource = self
        articleTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil),
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
            guard let idx = sender as? Int else { return }
            presenter.articleDidTap(withIndex: idx)
        default: break
        }
    }
}

extension FeedViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let chip = collectionView.dequeueReusableCell(withReuseIdentifier: UIMaterialChip.reuseIdentifier,
                                                      for: indexPath) as! UIMaterialChip
        chip.label.text = presenter.tags[indexPath.row]
        return chip
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let labelWidth = presenter.tags[indexPath.row].size(withAttributes: [.font: UIMaterialChip.labelFont]).width
        return CGSize(width: labelWidth + 40, height: 40)
    }
}

extension FeedViewController: HomeView {
    func presenterEvent(onTagsStateChange state: DataState<[String]>) {
        switch(state) {
        case .error(_): debugPrint("couldn't load tags")
        case .loaded(_):
            DispatchQueue.main.async {
                self.tagCollectionView.reloadData()
            }
        case .loading: debugPrint("loading tags")
        }
    }
    
    func presenterEvent(onArticlesStateChange state: DataState<[Article]>) {
        switch(state) {
        case .error(_): debugPrint("couldn't load articles")
        case .loaded(_):
            DispatchQueue.main.async {
                self.articleTableView.reloadData()
            }
        case .loading: debugPrint("loading articles")
        }
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.reuseIdentifier,
                                                 for: indexPath) as! ArticleTableViewCell
        let article = presenter.articles[indexPath.row]
        cell.authorLabel.text = article.author.username
        cell.titleLabel.text = article.title
        cell.dateCreatedLabel.text = DateFormatter.localizedString(from: article.createdAt,
                                                                   dateStyle: .medium,
                                                                   timeStyle: .short)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Segues.feedToArticle, sender: indexPath.row)
    }
}
