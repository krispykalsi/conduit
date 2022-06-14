//
//  FeedViewModel.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 14/06/22.
//

import Foundation

class FeedViewModel {
    @PostPublished var tags: DataState<[String]> = .loading
    @PostPublished var articles: DataState<[Article]> = .loading
}
