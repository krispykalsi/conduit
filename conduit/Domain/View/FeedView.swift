//
//  HomeView.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 20/05/22.
//

@MainActor protocol FeedView: AnyObject {
    func feedPresenter(didUpdateStateOf data: FeedViewData)
}

enum FeedViewData {
    case tags(DataState<[String]>)
    case articles(DataState<[Article]>)
}
