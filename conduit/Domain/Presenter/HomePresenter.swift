//
//  HomePresenter.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 20/05/22.
//

@MainActor protocol HomePresenter {
    var feedView: FeedView? { get set }

    func loadGlobalFeed()
    func loadMoreArticles()
}
