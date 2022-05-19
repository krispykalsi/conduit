//
//  HomePresenter.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 19/05/22.
//

import Foundation

final class HomeModel: HomePresenter {
    private init() {
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
        super.init(articleInteractor: interactor)
    }
    
    static let shared = HomeModel()
}
