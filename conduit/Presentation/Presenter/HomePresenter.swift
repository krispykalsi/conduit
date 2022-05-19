//
//  HomePresenter.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 19/05/22.
//
import Foundation

protocol HomeEventDelegate: AnyObject {
    func homeEvent(onTagsStateChange state: DataState<[String]>)
    func homeEvent(onArticlesStateChange state: DataState<[Article]>)
}

final class HomePresenter {
    init(articleInteractor: ArticleInteractor) {
        self.articleInteractor = articleInteractor
    }
    
    static let shared: HomePresenter = {
        let userDefaults = UserDefaults.standard
        let urlSession: URLSession
        if let token = userDefaults.string(forKey: "authToken") {
            let config = URLSessionConfiguration.default
            config.httpAdditionalHeaders = ["Authorization": "Token \(token)"]
            urlSession = URLSession(configuration: config)
        } else {
            urlSession = URLSession.shared
        }
        let api = ConduitApiClient(urlSession: urlSession)
        let interactor = ArticleRepository(dataSource: api)
        return HomePresenter(articleInteractor: interactor)
    }()
    
    private let articleInteractor: ArticleInteractor
    weak var eventDelegate: HomeEventDelegate?
    
    private(set) var tags: [String] = []
    private(set) var articles: [Article] = []
    private let articlesPagingLimit = 10
    
    func loadDataForHomeView() {
        eventDelegate?.homeEvent(onTagsStateChange: .loading)
        eventDelegate?.homeEvent(onArticlesStateChange: .loading)
        
        Task(priority: .userInitiated) {
            let feedParams = GlobalFeedParams(limit: articlesPagingLimit, offset: 0)
            async let tagsResult = articleInteractor.fetchTags()
            async let articlesResult = articleInteractor.fetchGlobalFeed(with: feedParams)
            
            switch(await tagsResult) {
            case .success(let newTags):
                tags = newTags
                eventDelegate?.homeEvent(onTagsStateChange: .loaded(newTags))
            case .failure(let error): debugPrint(error)
                eventDelegate?.homeEvent(onTagsStateChange: .error(error))
            }
            
            switch(await articlesResult) {
            case .success(let newArticles): debugPrint(newArticles)
                articles = newArticles
                eventDelegate?.homeEvent(onArticlesStateChange: .loaded(newArticles))
            case .failure(let error): debugPrint(error)
                eventDelegate?.homeEvent(onArticlesStateChange: .error(error))
            }
        }
    }
    
    func loadMoreArticles() {
        eventDelegate?.homeEvent(onTagsStateChange: .loading)
        eventDelegate?.homeEvent(onArticlesStateChange: .loading)
        
        Task(priority: .userInitiated) {
            let feedParams = GlobalFeedParams(limit: articlesPagingLimit, offset: articles.count)
            switch(await articleInteractor.fetchGlobalFeed(with: feedParams)) {
            case .success(let newArticles): debugPrint(newArticles)
                articles = newArticles
                eventDelegate?.homeEvent(onArticlesStateChange: .loaded(newArticles))
            case .failure(let error): debugPrint(error)
                eventDelegate?.homeEvent(onArticlesStateChange: .error(error))
            }
        }
    }
}
