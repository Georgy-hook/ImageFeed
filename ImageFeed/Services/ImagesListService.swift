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
    
    private var isFetchingPhotos = false
    
    func fetchPhotosNextPage(_ token: String) {
        
        guard !isFetchingPhotos else { return }
        isFetchingPhotos = true
        
        let nextPage = lastLoadedPage == nil
        ? 1
        : lastLoadedPage! + 1
        self.lastLoadedPage = nextPage
        task?.cancel()
        let request = ImagesListURLRequest(authToken: token, page: nextPage, perPage: 10)
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<PhotoResult, Error>) in
            guard let self = self else { return }
            self.isFetchingPhotos = false
            switch result {
            case .success(let body):
                body.forEach{ element in
                    self.photos.append(self.convertToPhoto(element: element))
                }
                NotificationCenter.default
                    .post(
                        name: ImagesListService.DidChangeNotification,
                        object: self,
                        userInfo: ["photoList": photos])
                
                self.task = nil
            case .failure(let error):
                print(error)
                self.isFetchingPhotos = false
            }
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void){
        let request: URLRequest?
        if isLike {
            request = ImagesDeleteLikeURLRequest(authToken: OAuth2TokenStorage.shared.token!, id: photoId)
        }
        else {
            request = ImagesLikeURLRequest(authToken: OAuth2TokenStorage.shared.token!, id: photoId)
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request!) {[weak self] data, response, error in
            guard let self = self else { return }            
            if let error = error {
                print("Error with like request:\(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            if let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode  {
                DispatchQueue.main.async {
                    // Поиск индекса элемента
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        // Текущий элемент
                        let photo = self.photos[index]
                        // Копия элемента с инвертированным значением isLiked.
                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            isLiked: !photo.isLiked
                        )
                        // Заменяем элемент в массиве.
                        self.photos[index] = newPhoto
                    }
                    completion(.success(()))  // Здесь мы вызываем completion с успехом
                }
            } else {
                DispatchQueue.main.async {
                    let error = NSError(domain:"", code:400, userInfo:[ NSLocalizedDescriptionKey: "Invalid server response"])
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

extension ImagesListService{
    private func ImagesListURLRequest(authToken: String, page: Int, perPage: Int) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/photos?page=\(page)&per_page=\(perPage)", httpMethod: "GET")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    private func ImagesLikeURLRequest(authToken: String, id: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/photos/\(id)/like", httpMethod: "POST")
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    private func ImagesDeleteLikeURLRequest(authToken: String, id: String) -> URLRequest {
        var request = URLRequest.makeHTTPRequest(path: "/photos/\(id)/like", httpMethod: "DELETE")
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
