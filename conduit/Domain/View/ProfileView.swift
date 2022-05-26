//
//  ProfileView.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 25/05/22.
//

@MainActor protocol ProfileView: AnyObject {
    func profilePresenter(didUpdateStateOf data: ProfileViewData)
    func profilePresenterRequiresAuth()
}

enum ProfileViewData {
    case profile(DataState<Profile>)
    case userArticles(DataState<[Article]>)
    case favoriteArticles(DataState<[Article]>)
}
