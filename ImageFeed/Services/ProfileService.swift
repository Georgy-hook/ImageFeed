//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Georgy on 09.07.2023.
//

import Foundation
import UIKit

final class ProfileService{
    static let shared = ProfileService()
    private init() {}
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    private(set) var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void){
        assert(Thread.isMainThread)
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        let request = selfProfileRequest(authToken: token)
        let task = object(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let personProfile = Profile(username: body.username,
                                            name: "\(body.firstName) \(body.lastName)",
                                            loginName: "@\(body.username)",
                                            bio: body.bio ?? "")
                self.profile = personProfile
                self.task = nil
                completion(.success(personProfile))
            case .failure(let error):
                completion(.failure(error))
                self.lastToken = nil
            }
        }
        self.task = task
        task.resume()
    }
}

extension ProfileService{
    private func selfProfileRequest(authToken: String) -> URLRequest {
        var request =  URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<ProfileResult, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<ProfileResult, Error> in
                Result { try decoder.decode(ProfileResult.self, from: data) }
            }
            completion(response)
        }
    }
}
