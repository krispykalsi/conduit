//
//  NavigationSegue.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 26/05/22.
//

enum NavigationSegue: String {
    case feedToArticle
    case articleToProfile
    case profileToArticle
}

func getSegue(_ id: NavigationSegue) -> String { id.rawValue }
