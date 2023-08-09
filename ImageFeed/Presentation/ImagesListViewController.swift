//
//  ViewController.swift
//  ImageFeed
//
//  Created by Georgy on 26.05.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {
    //MARK: - Outlets
    private let tableView:UITableView = {
        var tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.backgroundColor = UIColor(named: "YP Black")
        return tableView
    }()
    //MARK: - Variables
    var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    private let errorAlertService = ErrorAlertService.shared
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        applyConstraints()
        imagesListService.cleanPhotos()
        addObserver()
        imagesListService.fetchPhotosNextPage(OAuth2TokenStorage.shared.token!)
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = UIColor(named: "YP Black")
    }
}

//MARK: - TableView DataSource
extension ImagesListViewController:UITableViewDataSource{
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.selectionStyle = .none
        cell.configure(with: photos[indexPath.row], at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print("Error create cell")
            return UITableViewCell()
        }
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

//MARK: - TableView Delegate
extension ImagesListViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let photo = photos[indexPath.row]
        let imageWidth = CGFloat(photo.size.width)
        let imageViewWidth = tableView.bounds.width - 8
        let scale = imageViewWidth / imageWidth
        let cellHeight = CGFloat(photo.size.height) * scale + 8
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleImageViewController = SingleImageViewController()
        let imageURL = photos[indexPath.row].largeImageURL
        singleImageViewController.imageURL = imageURL
        singleImageViewController.modalPresentationStyle = .fullScreen
        present(singleImageViewController, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        imagesListService.fetchPhotosNextPage(OAuth2TokenStorage.shared.token!)
    }
}
//MARK: - Layout
private extension ImagesListViewController{
    func applyConstraints(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    func addSubviews(){
        view.addSubview(tableView)
    }
}

//MARK: - Preferred Status Bar
extension ImagesListViewController{
    override var preferredStatusBarStyle: UIStatusBarStyle{
        .lightContent
    }
}

//MARK: - Notification center
extension ImagesListViewController{
    private func addObserver(){
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
        updateTableViewAnimated()
    }
    func updateTableViewAnimated(){
        let oldCount = photos.count
        photos = imagesListService.photos
        let newCount = photos.count
        
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

//MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]

        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) {[weak self] result in
            guard let self = self else {return}
            switch result {
            case .success:

                self.photos = self.imagesListService.photos
                cell.switchLikeButtonState(to: self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                
                self.errorAlertService.showAlert(on: self, with: .unknownError){
                    
                }
            }
        }
    }
}
