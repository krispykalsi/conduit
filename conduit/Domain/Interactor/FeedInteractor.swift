//
//  FeedInteractor.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 14/06/22.
//
import Combine
import UIKit

class FeedInteractor {
    init(articleRepository: IArticleRepository, localAuthService: ILocalAuthService) {
        self.articleRepository = articleRepository
        self.localAuthService = localAuthService
    }
    
    private let articleRepository: IArticleRepository
    private let localAuthService: ILocalAuthService
    
    private let articlesPagingLimit = 10
    
    static let shared = FeedInteractor(articleRepository: ConduitAPI.shared,
                                       localAuthService: LocalAuthService.shared)
    
    func loadFeedData(afterArticle articleNumber: Int = 0) -> AnyPublisher<FeedOutput, FeedError> {
        let subject = PassthroughSubject<FeedOutput, FeedError>()
        Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { [unowned self] in
                    do {
                        try await subject.send(.tags(articleRepository.fetchTags()))
                    } catch {
                        subject.send(completion: .failure(.failedToLoadTags(dueTo: error)))
                    }
                }
                group.addTask { [unowned self] in
                    do {
                        try await subject.send(.articles(fetchArticles(after: articleNumber)))
                    } catch {
                        subject.send(completion: .failure(.failedToLoadArticles(dueTo: error)))
                    }
                }
                await group.waitForAll()
                subject.send(completion: .finished)
                
            }
        }
        return subject.eraseToAnyPublisher()
    }
    
    private func fetchArticles(after offset: Int) async throws -> [Article] {
        if localAuthService.isUserLoggedIn {
            let feedParams = UserFeedParams(limit: articlesPagingLimit, offset: offset)
            return try await articleRepository.fetchUserFeed(with: feedParams)
        } else {
            let feedParams = GlobalFeedParams(limit: articlesPagingLimit, offset: offset)
            return try await articleRepository.fetchGlobalFeed(with: feedParams)
        }
    }
}

enum FeedError: Error {
    case failedToLoadTags(dueTo: Error)
    case failedToLoadArticles(dueTo: Error)
}

enum FeedOutput {
    case tags([String])
    case articles([Article])
}
