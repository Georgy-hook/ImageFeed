//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Georgy on 02.07.2023.
//

import Foundation
final class OAuth2TokenStorage{
    static let shared = OAuth2TokenStorage()
    private init() {}
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case token
    }
    var token: String?{
        get{
            guard let token = userDefaults.string(forKey: Keys.token.rawValue) else{
                return nil
            }
            return token
        }
        set{
            userDefaults.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
