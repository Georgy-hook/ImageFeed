//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Georgy on 09.07.2023.
//

import UIKit

final class ProfileImageService{
    static let shared = ProfileImageService()
    private init() {}
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    private (set) var avatarURL: String?
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    func fetchProfileImageURL(username: String, _ token:String, _ completion: @escaping (Result<String, Error>) -> Void){
        NotificationCenter.default
            .post(
                name: ProfileImageService.didChangeNotification,
                object: self,
                userInfo: ["URL": avatarURL])
        
        guard lastToken != token else { return }
        task?.cancel()
        lastToken = token
        let request = profileImageURLRequest(username: username, authToken: token)
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let avatar = body.profileImage.small
                self.avatarURL = avatar
                self.task = nil
                completion(.success(avatar))
            case .failure(let error):
                completion(.failure(error))
                self.lastToken = nil
            }
        }
        self.task = task
        task.resume()
    }
}

extension ProfileImageService{
    private func profileImageURLRequest(username: String, authToken: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
}

