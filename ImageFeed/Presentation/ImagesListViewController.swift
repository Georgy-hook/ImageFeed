//
//  ViewController.swift
//  ImageFeed
//
//  Created by Georgy on 26.05.2023.
//

import UIKit

protocol ImagesListViewControllerProtocol:AnyObject{
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated(with indexPaths:[IndexPath])
    func showAlert()
}

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
    private var imagesListServiceObserver: NSObjectProtocol?
    private let errorAlertService = ErrorAlertService.shared
    var presenter: ImagesListPresenterProtocol?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        applyConstraints()
        addObserver()
        
        presenter?.viewDidLoad()
        
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.backgroundColor = UIColor(named: "YP Black")
    }
}

//MARK: - TableView DataSource
extension ImagesListViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getCountOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print("Error create cell")
            return UITableViewCell()
        }
        imageListCell.delegate = self
        presenter?.configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

//MARK: - TableView Delegate
extension ImagesListViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        guard let cellHeight = presenter?.getCellHeight(for: tableView.bounds.width,
                                                        with: indexPath)
        else {return 0}
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleImageViewController = SingleImageViewController()
        let imageURL = presenter?.getImageURL(with: indexPath)
        singleImageViewController.imageURL = imageURL
        singleImageViewController.modalPresentationStyle = .fullScreen
        present(singleImageViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.fetchPhotos()
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
                self.presenter?.shouldUpdateTableView()
            }
        presenter?.shouldUpdateTableView()
    }
}

//MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.likeButtonTapped(cell, for: indexPath)
    }
}

//MARK: - ImagesListViewControllerProtocol
extension ImagesListViewController:ImagesListViewControllerProtocol{
    
    func updateTableViewAnimated(with indexPaths:[IndexPath]){
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
    
    func showAlert(){
        errorAlertService.showAlert(on: self, with: .unknownError){
            
        }
    }
}
