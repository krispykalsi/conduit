//
//  FollowButton.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 01/06/22.
//

import UIKit

@IBDesignable
class FollowButton: UIButton {
    enum State {
        case follow, unfollow
    }
    
    @IBInspectable var compact: Bool = false
    
    func changeTo(_ state: State) {
        switch(state) {
        case .follow:
            configuration = followConfiguration
        case .unfollow:
            configuration = unfollowConfiguration
        }
    }
    
    private var followConfiguration: UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.title = "Follow"
        updateIfCompact(&config)
        return config.updated(for: self)
    }
    
    private var unfollowConfiguration: UIButton.Configuration {
        var config = UIButton.Configuration.borderedTinted()
        config.cornerStyle = .capsule
        config.title = "Unfollow"
        updateIfCompact(&config)
        return config.updated(for: self)
    }
    
    private func updateIfCompact(_ config: inout UIButton.Configuration) {
        if compact {
            config.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10)
        } else {
            config.setDefaultContentInsets()
        }
    }
}
