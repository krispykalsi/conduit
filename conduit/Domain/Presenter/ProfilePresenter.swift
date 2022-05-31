//
//  ProfilePresenter.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 25/05/22.
//

@MainActor protocol ProfilePresenter {
    var profileView: ProfileView? { get set }
    
    func fetchCurrentUserProfileData()
    func fetchArticleData(for username: String)
    func logOut()
}
