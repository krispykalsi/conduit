//
//  DataState.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 19/05/22.
//

enum DataState<E> {
    case loading
    case loaded(E)
    case error(Error)
}
