//
//  ProfileModel.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 25/05/22.
//

class ProfileModel {
    internal init(localAuthService: ILocalAuthService,
                  profileRepository: IProfileRepository,
                  articleRepository: IArticleRepository) {
        self.localAuthService = localAuthService
        self.profileRepository = profileRepository
        self.articleRepository = articleRepository
    }
    
    private let localAuthService: ILocalAuthService
    private let profileRepository: IProfileRepository
    private let articleRepository: IArticleRepository
    
    private var profile: Profile?
    private var userArticles: [Article]?
    private var favArticles: [Article]?
    
    weak var profileView: ProfileView?
    
    static let shared = ProfileModel(localAuthService: LocalAuthService.shared,
                                     profileRepository: ConduitAPI.shared,
                                     articleRepository: ConduitAPI.shared)
}

extension ProfileModel: ProfilePresenter {
    func followUser(with username: String) {
        profileView?.profilePresenter(didUpdateFollowState: .inProgress)
        Task {
            do {
                _ = try await profileRepository.followProfile(with: username)
                profileView?.profilePresenter(didUpdateFollowState: .success)
            } catch {
                let msg = error.localizedDescription
                profileView?.profilePresenter(didUpdateFollowState: .failure(msg))
            }
        }
    }
    
    func unfollowUser(with username: String) {
        profileView?.profilePresenter(didUpdateUnfollowState: .inProgress)
        Task {
            do {
                _ = try await profileRepository.unfollowProfile(with: username)
                profileView?.profilePresenter(didUpdateUnfollowState: .success)
            } catch {
                let msg = error.localizedDescription
                profileView?.profilePresenter(didUpdateUnfollowState: .failure(msg))
            }
        }
    }
    
    func fetchCurrentUserProfileData() {
        if let username = localAuthService.username {
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
                let profile = try await profileRepository.fetchProfile(with: username)
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
            async let userArticlesAsync = try articleRepository.fetchGlobalFeed(with: GlobalFeedParams(author: username))
            async let favArticlesAsync = try articleRepository.fetchGlobalFeed(with: GlobalFeedParams(favorited: username))
            
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
    
    func logOut() {
        localAuthService.clearAuthDetailsFromCache()
        profileView?.profilePresenterRequiresAuth()
    }
}
