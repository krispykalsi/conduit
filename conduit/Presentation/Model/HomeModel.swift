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
        let api = DataService(urlSession: urlSession,
                                   jsonEncoder: JSONEncoder(),
                                   jsonDecoder: decoder)
        return HomeModel(articleInteractor: api)
    }()
    
    private let articleInteractor: ArticleInteractor
    weak var view: HomeView?
    
    private var tags: [String] = []
    private var articles: [Article] = []
    
    private let articlesPagingLimit = 10
    
    func loadDataForHomeView() {
        view?.presenterEvent(onTagsStateChange: .loading)
        view?.presenterEvent(onArticlesStateChange: .loading)
        Task(priority: .userInitiated) {
            let feedParams = GlobalFeedParams(limit: articlesPagingLimit, offset: 0)
            async let newTags = articleInteractor.fetchTags()
            async let newArticles = articleInteractor.fetchGlobalFeed(with: feedParams)
            
            do {
                tags = try await newTags
                view?.presenterEvent(onTagsStateChange: .loaded(tags))
            } catch {
                view?.presenterEvent(onTagsStateChange: .error(error))
            }
            
            do {
                articles = try await newArticles
                view?.presenterEvent(onArticlesStateChange: .loaded(articles))
            } catch {
                view?.presenterEvent(onArticlesStateChange: .error(error))
            }
        }
    }
    
    func loadMoreArticles() {
        view?.presenterEvent(onArticlesStateChange: .loading)
        Task(priority: .userInitiated) {
            let feedParams = GlobalFeedParams(limit: articlesPagingLimit, offset: articles.count)
            do {
                let newArticles = try await articleInteractor.fetchGlobalFeed(with: feedParams)
                articles.append(contentsOf: newArticles)
                view?.presenterEvent(onArticlesStateChange: .loaded(articles))
            } catch {
                view?.presenterEvent(onArticlesStateChange: .error(error))
            }
        }
    }
}
