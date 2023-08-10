//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Georgy on 09.08.2023.
//

import Foundation

protocol ImagesListPresenterProtocol{
    var view:  ImagesListViewControllerProtocol? { get set }
    func viewDidLoad()
    func fetchPhotos()
    func getCountOfRows() -> Int
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
    func getCellHeight(for tableViewWidth: CGFloat , with indexPath: IndexPath) -> CGFloat
    func shouldUpdateTableView()
    func likeButtonTapped(_ cell: ImagesListCell, for indexPath:IndexPath)
    func getImageURL(with indexPath:IndexPath) -> String
}
class ImagesListPresenter:ImagesListPresenterProtocol{
    // MARK: - Variables
    var view: ImagesListViewControllerProtocol?
    private let imagesListService = ImagesListService.shared
    private let errorAlertService = ErrorAlertService.shared
    var photos: [Photo] = []
    // MARK: - ImagesListPresenterProtocol
    func viewDidLoad() {
        imagesListService.cleanPhotos()
        fetchPhotos()
    }
    func fetchPhotos(){
        imagesListService.fetchPhotosNextPage(OAuth2TokenStorage.shared.token!)
    }
    func getCountOfRows() -> Int {
        return photos.count
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.selectionStyle = .none
        cell.configure(with: photos[indexPath.row], at: indexPath)
    }
    
    func getCellHeight(for tableViewWidth: CGFloat , with indexPath: IndexPath) -> CGFloat{
        let photo = photos[indexPath.row]
        let imageWidth = CGFloat(photo.size.width)
        let imageViewWidth = tableViewWidth - 8
        let scale = imageViewWidth / imageWidth
        let cellHeight = CGFloat(photo.size.height) * scale + 8
        guard cellHeight > 0 else {return 0}
        return cellHeight
    }
    
    func shouldUpdateTableView() {
        let oldCount = photos.count
        photos = imagesListService.photos
        let newCount = photos.count
        if oldCount != newCount {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            view?.updateTableViewAnimated(with: indexPaths)
        }
    }
    
    func likeButtonTapped(_ cell: ImagesListCell, for indexPath: IndexPath) {
        
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                cell.switchLikeButtonState(to: self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
                
            case .failure(_):
                UIBlockingProgressHUD.dismiss()
                view?.showAlert()

            }
            
        }
    }
    
    func getImageURL(with indexPath:IndexPath) -> String {
        return photos[indexPath.row].largeImageURL
    }
}
