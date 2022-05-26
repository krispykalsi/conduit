//
//  Requests.swift
//  conduit
//
//  Created by Ikroop Singh Kalsi on 18/05/22.
//

struct LoginUserRequest: Encodable {
    let user: LoginViaEmailParams
}

struct RegisterUserRequest: Encodable {
    let user: RegisterViaEmailParams
}

struct UpdateUserRequest: Encodable {
    let user: UpdateUserParams
}

struct CreateArticleRequest: Encodable {
    let article: CreateArticleParams
}

struct UpdateArticleRequest: Encodable {
    let article: UpdateArticleParams
}

struct NewCommentRequest: Encodable {
    init(withBody body: String) {
        comment["body"] = body
    }
    private var comment = [String: String]()
}
