//
//  FeedViewController.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 19/05/22.
//

import UIKit
import Combine

class FeedViewController: UIViewController {
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet weak var articleTableView: UITableView!
    
    private var presenter = HomePresenter.shared
    
    private var viewModelSubscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTagCollectionView()
        setupArticleTableView()
        subscribeToFeedViewModel()
        presenter.fetchFeedData()
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
    
    private func subscribeToFeedViewModel() {
        presenter.feedViewModel.$tags.receive(on: DispatchQueue.main).sink { [weak self] in
            self?.tagCollectionView.reloadData()
        }.store(in: &viewModelSubscriptions)
        
        presenter.feedViewModel.$articles.receive(on: DispatchQueue.main).sink { [weak self] in
            self?.articleTableView.reloadData()
        }.store(in: &viewModelSubscriptions)
    }
}

extension FeedViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch(presenter.feedViewModel.tags) {
        case .loaded(let tags):
            return tags.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let chip = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionViewCell.reuseIdentifier, for: indexPath) as! TagCollectionViewCell
        switch(presenter.feedViewModel.tags) {
        case .loaded(let tags):
            chip.label.text = tags[indexPath.row]
        case .loading:
            chip.label.text = "Loading..."
        case .error(_):
            chip.label.text = "Failed to load tags"
            chip.label.textColor = .red
        }
        return chip
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var text: String
        switch(presenter.feedViewModel.tags) {
        case .loaded(let tags):
            text = tags[indexPath.row]
        case .loading:
            text = "Loading..."
        case .error(_):
            text = "Failed to load tags"
        }
        let labelWidth = text.size(withAttributes: [.font: TagCollectionViewCell.labelFont]).width
        return CGSize(width: labelWidth + 40, height: 40)
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(presenter.feedViewModel.articles) {
        case .loaded(let articles):
            return articles.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCell.reuseIdentifier, for: indexPath) as! ArticleTableViewCell
        switch(presenter.feedViewModel.articles) {
        case .loaded(let articles):
            let article = articles[indexPath.row]
            cell.populateValues(from: article)
        case .loading:
            cell.titleLabel.text = "Loading..."
        case .error(_):
            cell.titleLabel.text = "Failed to load articles"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case let .loaded(articles) = presenter.feedViewModel.articles {
            Router.shared.navigate(from: self, to: .articleView(articles[indexPath.row]))
        }
    }
}
