//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Georgy on 02.07.2023.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue!
        }
    }
    func fetchOAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let request = authTokenRequest(code: code)
        let task = object(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
extension OAuth2Service {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthToken, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthToken, Error> in
                Result { try decoder.decode(OAuthToken.self, from: data) }
            }
            completion(response)
        }
    }
    private func authTokenRequest(code: String) -> URLRequest {
        URLRequest.makeHTTPRequest(
            path: "/oauth/token"
            + "?client_id=\(AccessKey)"
            + "&&client_secret=\(SecretKey)"
            + "&&redirect_uri=\(RedirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: URL(string: "https://unsplash.com")!
        )
    }
}
