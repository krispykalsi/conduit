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
        
    func navigate(from controller: UIViewController, to destinationView: DestinationView) {
        switch(destinationView) {
        case .articleView(let article):
            let vc: ArticleViewController = instantiateViewController()
            vc.article = article
            controller.navigationController?.pushViewController(vc, animated: true)
        case .profileView(let profile):
            let vc: ProfileViewController = instantiateViewController()
            vc.isOwnProfile = false
            vc.profile = profile
            controller.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

enum DestinationView {
    case articleView(Article)
    case profileView(Profile)
}
