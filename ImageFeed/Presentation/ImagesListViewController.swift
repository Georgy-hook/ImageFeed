//
//  ViewController.swift
//  ImageFeed
//
//  Created by Georgy on 26.05.2023.
//

import UIKit

class ImagesListViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet private var tableView: UITableView!
    
    //MARK: - Variables
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
}

//MARK: - TableView DataSource
extension ImagesListViewController:UITableViewDataSource{
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.imageCell.image = UIImage(named: "\(indexPath.row)")
        cell.dateLabel.text = Date().dateString
        if indexPath.row % 2 == 0{
            cell.likeButton.setImage(UIImage(named: "Active"), for: .normal)
        }else{
            cell.likeButton.setImage(UIImage(named: "No Active"), for: .normal)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print("Error create cell")
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    
}

//MARK: - TableView Delegate
extension ImagesListViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        let imageWidth = image.size.width
        let imageViewWidth = tableView.bounds.width - 8
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + 8
        return cellHeight
    }
}
