//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Georgy on 02.07.2023.
//

import Foundation
import SwiftKeychainWrapper
final class OAuth2TokenStorage{
    static let shared = OAuth2TokenStorage()
    private init() {}
    private let keyChain = KeychainWrapper.standard
    private let userDefaults = UserDefaults.standard
    private enum Keys: String {
        case token
    }
    var token: String?{
        get{
            guard let token = keyChain.string(forKey:Keys.token.rawValue ) else{
                return nil
            }
            return token
        }
        set{
            guard let newValue = newValue else {
                keyChain.removeObject(forKey: Keys.token.rawValue)
                return
            }
            keyChain.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
