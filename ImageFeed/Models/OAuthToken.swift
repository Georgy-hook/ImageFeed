//
//  OAuthToken.swift
//  ImageFeed
//
//  Created by Georgy on 02.07.2023.
//

import Foundation

// MARK: - OAuthToken
struct OAuthToken: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}
