//
//  HomePresenter.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 20/05/22.
//

import Combine

class HomePresenter {
    internal init(feedInteractor: FeedInteractor, feedViewModel: FeedViewModel) {
        self.feedInteractor = feedInteractor
        self.feedViewModel = feedViewModel
    }
    
    private let feedInteractor: FeedInteractor
    let feedViewModel: FeedViewModel
    
    private var subscribers = Set<AnyCancellable>()
        
    static let shared = HomePresenter(feedInteractor: FeedInteractor.shared,
                                      feedViewModel: FeedViewModel())
    
    func fetchFeedData() {
        let feedDataPublisher = feedInteractor.loadFeedData()
        feedDataPublisher.sink { completion in
            if case let .failure(error) = completion {
                switch(error) {
                case .failedToLoadTags(dueTo: let error):
                    self.feedViewModel.tags = .error(error)
                case .failedToLoadArticles(dueTo: let error):
                    self.feedViewModel.articles = .error(error)
                }
                debugPrint(error)
            }
        } receiveValue: { feedOutput in
            switch(feedOutput) {
            case .tags(let tags):
                self.feedViewModel.tags = .loaded(tags)
            case .articles(let articles):
                self.feedViewModel.articles = .loaded(articles)
            }
        }.store(in: &subscribers)
    }
}
