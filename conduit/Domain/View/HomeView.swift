//
//  HomeView.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 20/05/22.
//

protocol HomeView: AnyObject {
    func presenterEvent(onTagsStateChange state: DataState<[String]>)
    func presenterEvent(onArticlesStateChange state: DataState<[Article]>)
}

extension HomeView {
    func presenterEvent(onTagsStateChange state: DataState<[String]>) {}
    func presenterEvent(onArticlesStateChange state: DataState<[Article]>) {}
}
