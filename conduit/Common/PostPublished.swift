//
//  PostPublished.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 15/06/22.
//

import Combine

/// A type that publishes changes about its `wrappedValue` property _after_ the property has changed (using `didSet` semantics).
/// Reimplementation of `Combine.Published`, which uses `willSet` semantics.
@propertyWrapper struct PostPublished<Value> {
    var wrappedValue: Value {
        didSet { didChangeSubject.send() }
    }

    /// A `Publisher` that fires whenever `wrappedValue` _was_ mutated. To access the new value of `wrappedValue`, access `wrappedValue` directly, this `Publisher` only signals a change, it doesn't contain the changed value.
    private let didChangeSubject: PassthroughSubject<Void, Never>
    let projectedValue: AnyPublisher<Void, Never>

    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
        didChangeSubject = PassthroughSubject<Void, Never>()
        projectedValue = didChangeSubject.eraseToAnyPublisher()
    }
}
