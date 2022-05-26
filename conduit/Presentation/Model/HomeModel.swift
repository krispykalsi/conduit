//
//  HomePresenter.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 19/05/22.
//

final class HomeModel {
    init(articleInteractor: ArticleInteractor) {
        self.articleInteractor = articleInteractor
    }
    
    private let articleInteractor: ArticleInteractor
    
    private var tags: [String] = []
    private var articles: [Article] = []
    private let articlesPagingLimit = 10
    
    static let shared = HomeModel(articleInteractor: DataSource.shared)
    
    weak var feedView: FeedView?
}

extension HomeModel: HomePresenter {
    func loadGlobalFeed() {
        feedView?.feedView(didUpdateStateOf: .tags(.loading))
        feedView?.feedView(didUpdateStateOf: .articles(.loading))
        Task(priority: .userInitiated) {
            let feedParams = GlobalFeedParams(limit: articlesPagingLimit, offset: 0)
            async let newTags = articleInteractor.fetchTags()
            async let newArticles = articleInteractor.fetchGlobalFeed(with: feedParams)
            
            do {
                tags = try await newTags
                feedView?.feedView(didUpdateStateOf: .tags(.loaded(tags)))
            } catch {
                feedView?.feedView(didUpdateStateOf: .tags(.error(error)))
            }
            
            do {
                articles = try await newArticles
                feedView?.feedView(didUpdateStateOf: .articles(.loaded(articles)))
            } catch {
                feedView?.feedView(didUpdateStateOf: .articles(.error(error)))
            }
        }
    }
    
    func loadMoreArticles() {
        feedView?.feedView(didUpdateStateOf: .articles(.loading))
        Task(priority: .userInitiated) {
            let feedParams = GlobalFeedParams(limit: articlesPagingLimit, offset: articles.count)
            do {
                let newArticles = try await articleInteractor.fetchGlobalFeed(with: feedParams)
                articles.append(contentsOf: newArticles)
                feedView?.feedView(didUpdateStateOf: .articles(.loaded(articles)))
            } catch {
                feedView?.feedView(didUpdateStateOf: .articles(.error(error)))
            }
        }
    }
}
