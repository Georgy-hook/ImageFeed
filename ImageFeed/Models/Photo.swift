//
//  Photo.swift
//  ImageFeed
//
//  Created by Georgy on 21.07.2023.
//

import Foundation

// MARK: - PhotoResultElement
struct PhotoResultElement: Codable {
    let id: String
    let createdAt, updatedAt: String
    let width, height: Int
    let color, blurHash: String
    let likes: Int
    let likedByUser: Bool
    let description: String?
    let user: User
    let urls: Urls

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width, height, color
        case blurHash = "blur_hash"
        case likes
        case likedByUser = "liked_by_user"
        case description, user, urls
    }
}

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small: String
    let thumb: String
}

// MARK: - User
struct User: Codable {
}

typealias PhotoResult = [PhotoResultElement]

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
