//
//  ProfileModel.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 25/05/22.
//

class ProfileModel {
    internal init(authInteractor: AuthInteractor,
                  profileInteractor: ProfileInteractor,
                  articleInteractor: ArticleInteractor) {
        self.authInteractor = authInteractor
        self.profileInteractor = profileInteractor
        self.articleInteractor = articleInteractor
    }
    
    private let authInteractor: AuthInteractor
    private let profileInteractor: ProfileInteractor
    private let articleInteractor: ArticleInteractor
    
    private var profile: Profile?
    private var userArticles: [Article]?
    private var favArticles: [Article]?
    
    weak var profileView: ProfileView?
    
    static let shared = ProfileModel(authInteractor: AuthService.shared,
                                     profileInteractor: DataSource.shared,
                                     articleInteractor: DataSource.shared)
}

extension ProfileModel: ProfilePresenter {
    func fetchCurrentUserProfileData() {
        if let username = authInteractor.username {
            fetchProfileData(for: username)
            fetchArticleData(for: username)
        } else {
            profileView?.profilePresenterRequiresAuth()
        }
    }
    
    @MainActor private func fetchProfileData(for username: String) {
        Task {
            profileView?.profilePresenter(didUpdateStateOf: .profile(.loading))
            do {
                let profile = try await profileInteractor.fetchProfile(with: username)
                profileView?.profilePresenter(didUpdateStateOf: .profile(.loaded(profile)))
            } catch {
                profileView?.profilePresenter(didUpdateStateOf: .profile(.error(error)))
            }
        }
    }
    
    func fetchArticleData(for username: String) {
        profileView?.profilePresenter(didUpdateStateOf: .userArticles(.loading))
        profileView?.profilePresenter(didUpdateStateOf: .favoriteArticles(.loading))
        
        Task {
            async let userArticlesAsync = try articleInteractor.fetchGlobalFeed(with: GlobalFeedParams(author: username))
            async let favArticlesAsync = try articleInteractor.fetchGlobalFeed(with: GlobalFeedParams(favorited: username))
            
            do {
                let userArticles = try await userArticlesAsync
                profileView?.profilePresenter(didUpdateStateOf: .userArticles(.loaded(userArticles)))
            } catch {
                profileView?.profilePresenter(didUpdateStateOf: .userArticles(.error(error)))
            }
            
            do {
                let favArticles = try await favArticlesAsync
                profileView?.profilePresenter(didUpdateStateOf: .favoriteArticles(.loaded(favArticles)))
            } catch {
                profileView?.profilePresenter(didUpdateStateOf: .favoriteArticles(.error(error)))
            }
        }
    }
}
