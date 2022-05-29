//
//  StringExtensions.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 30/05/22.
//

extension String {
    func doesSatisfy(regex: String) -> Bool {
        return range(of: regex, options: .regularExpression) != nil
    }
}

