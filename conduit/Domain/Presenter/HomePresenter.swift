//
//  HomePresenter.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 20/05/22.
//

protocol HomePresenter {
    var view: HomeView? { get set }

    func loadDataForHomeView()
    func loadMoreArticles()
}
