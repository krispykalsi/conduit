//
//  HomePresenter.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 20/05/22.
//

protocol HomePresenter {
    var view: HomeView? { get set }
    
    var tags: [String] { get }
    var articles: [Article] { get }
    var selectedArticle: Article? { get }
    
    func loadDataForHomeView()
    func loadMoreArticles()
    func articleDidTap(withIndex index: Int)
}
