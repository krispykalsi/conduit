//
//  Router.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 27/05/22.
//

import UIKit

class Router {
    private let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    static let shared = Router()
    
    private func instantiateViewController<T>() -> T {
        let storyboardId = String(describing: T.self)
        return storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
    }
    
    private func initialize(destinationView: DestinationView) -> UIViewController {
        var viewController: UIViewController
        switch(destinationView) {
        case .articleView(let article):
            let vc: ArticleViewController = instantiateViewController()
            vc.article = article
            viewController = vc
        case .profileView(let profile):
            let vc: ProfileViewController = instantiateViewController()
            vc.isOwnProfile = false
            vc.profile = profile
            viewController = vc
        case .loginView:
            let vc: LoginViewController = instantiateViewController()
            viewController = vc
        }
        return viewController
    }
        
    func navigate(from controller: UIViewController, to destinationView: DestinationView) {
        let vc = initialize(destinationView: destinationView)
        controller.navigationController?.pushViewController(vc, animated: true)
    }
    
    func replace(_ controller: UIViewController, with destinationView: DestinationView) {
        let vc = initialize(destinationView: destinationView)
        guard var vcs = controller.navigationController?.viewControllers else { return }
        vcs[vcs.count-1] = vc
        controller.navigationController?.setViewControllers(vcs, animated: true)
    }
}

enum DestinationView {
    case articleView(Article)
    case profileView(Profile)
    case loginView
}
