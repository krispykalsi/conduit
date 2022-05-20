//
//  HomePresenter.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 19/05/22.
//
import Foundation

final class HomeModel: HomePresenter {
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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = JSONDecoder.DateDecodingStrategy.formatted(formatter)
        let api = ConduitApiClient(urlSession: urlSession,
                                   jsonEncoder: JSONEncoder(),
                                   jsonDecoder: decoder)
        let interactor = ArticleRepository(dataSource: api)
        return HomeModel(articleInteractor: interactor)
    }()
    
    private let articleInteractor: ArticleInteractor
    weak var view: HomeView?
    
    private(set) var tags: [String] = []
    private(set) var articles: [Article] = []
    private(set) var selectedArticle: Article?
    
    private let articlesPagingLimit = 10
    
    func loadDataForHomeView() {
        view?.presenterEvent(onTagsStateChange: .loading)
        view?.presenterEvent(onArticlesStateChange: .loading)
        
        Task(priority: .userInitiated) {
            let feedParams = GlobalFeedParams(limit: articlesPagingLimit, offset: 0)
            async let tagsResult = articleInteractor.fetchTags()
            async let articlesResult = articleInteractor.fetchGlobalFeed(with: feedParams)
            
            switch(await tagsResult) {
            case .success(let newTags):
                tags = newTags
                view?.presenterEvent(onTagsStateChange: .loaded(newTags))
            case .failure(let error): debugPrint(error)
                view?.presenterEvent(onTagsStateChange: .error(error))
            }
            
            switch(await articlesResult) {
            case .success(let newArticles):
                articles = newArticles
                view?.presenterEvent(onArticlesStateChange: .loaded(newArticles))
            case .failure(let error): debugPrint(error)
                view?.presenterEvent(onArticlesStateChange: .error(error))
            }
        }
    }
    
    func loadMoreArticles() {
        view?.presenterEvent(onTagsStateChange: .loading)
        view?.presenterEvent(onArticlesStateChange: .loading)
        
        Task(priority: .userInitiated) {
            let feedParams = GlobalFeedParams(limit: articlesPagingLimit, offset: articles.count)
            switch(await articleInteractor.fetchGlobalFeed(with: feedParams)) {
            case .success(let newArticles): debugPrint(newArticles)
                articles = newArticles
                view?.presenterEvent(onArticlesStateChange: .loaded(newArticles))
            case .failure(let error): debugPrint(error)
                view?.presenterEvent(onArticlesStateChange: .error(error))
            }
        }
    }
    
    func articleDidTap(withIndex index: Int) {
        selectedArticle = articles[index]
    }
}
