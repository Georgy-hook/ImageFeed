//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Georgy on 21.07.2023.
//

import Foundation
final class ImagesListService {
    
    static let shared = ImagesListService()
    private init() {}
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListProviderDidChange")
    
    // ...
    
    func fetchPhotosNextPage(_ token: String) {
        NotificationCenter.default
            .post(
                name: ImagesListService.DidChangeNotification,
                object: self,
                userInfo: ["photoList": photos])
        
        let nextPage = lastLoadedPage == nil
        ? 1
        : lastLoadedPage! + 1
        
        task?.cancel()
        
        let request = ImagesListURLRequest(authToken: token, page: nextPage, perPage: 10)
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<PhotoResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                body.forEach{ element in
                    self.photos.append(self.convertToPhoto(element: element))
                    print(element)
                }
                self.task = nil
            case .failure(let error):
                print(error)
                self.lastLoadedPage = nil
            }
        }
        self.task = task
        task.resume()
    }
}

extension ImagesListService{
    private func ImagesListURLRequest(authToken: String, page: Int, perPage: Int) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/photos?page=\(page)&per_page=\(perPage)", httpMethod: "GET")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    private func convertToPhoto(element: PhotoResultElement) -> Photo{
        return Photo(id: element.id,
                     size: CGSize(width: element.width, height: element.height),
                     createdAt: element.createdAt.getDate(),
                     welcomeDescription: element.description,
                     thumbImageURL: element.urls.thumb,
                     largeImageURL: element.urls.full,
                     isLiked: element.likedByUser)
    }
}
