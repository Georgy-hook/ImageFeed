//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Georgy on 09.07.2023.
//

import Foundation

//MARK: - Network profile model
struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

//MARK: - UI profile model
struct Profile{
    let username: String
    let name: String
    let loginName: String
    let bio: String
}

//MARK: - Network profile image model
    struct UserResult: Codable {
        let profileImage: ProfileImage
        
        enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
    }
    
    struct ProfileImage: Codable {
        let small: String
    }
