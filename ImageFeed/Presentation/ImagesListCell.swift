//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Georgy on 28.05.2023.
//

import UIKit
import Kingfisher

class ImagesListCell: UITableViewCell {
    
    //MARK: - Variables
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    //MARK: - UI Elements
    private var imageCell: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "SFPro-Regular", size: 13)
        return label
    }()
    
    private let gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        setupViews()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = gradientView.bounds
        }
    }
    
    // MARK: - Button actions
    @objc private func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
}

//MARK: - Layout
extension ImagesListCell{
    
    private func setupViews() {
        contentView.addSubview(imageCell)
        contentView.addSubview(likeButton)
        contentView.addSubview(dateLabel)
        contentView.addSubview(gradientView)
        let blue = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0)
        let green = UIColor(red: 26/255, green: 27/255, blue: 34/255, alpha: 0.2)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [blue.cgColor, green.cgColor]
        gradientLayer.locations = [0, 1]
        gradientView.layer.addSublayer(gradientLayer)
        gradientLayer.frame = gradientView.bounds
    }
    
    private func applyConstraints(){
        NSLayoutConstraint.activate([
            imageCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            imageCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            likeButton.topAnchor.constraint(equalTo: imageCell.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            dateLabel.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: imageCell.bottomAnchor, constant: -8),
            gradientView.bottomAnchor.constraint(equalTo: imageCell.bottomAnchor),
            gradientView.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor),
            gradientView.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}

//MARK: - Configure cell
extension ImagesListCell{
    func switchLikeButtonState(to isLiked: Bool){
        if isLiked {
            likeButton.setImage(UIImage(named: "Active"), for: .normal)
        }else{
            likeButton.setImage(UIImage(named: "No Active"), for: .normal)
        }
    }
    func configure(with photo:Photo, at indexPath: IndexPath){
        let url = URL(string: photo.thumbImageURL)
        imageCell.kf.indicatorType = .activity
        imageCell.kf.setImage(with: url,
                              placeholder: UIImage(named: "Placeholder_ImageList"),
                              options: [],
                              completionHandler:  { result in
                                  switch result {
                                  case .success(_):
                                      return
                                  case .failure(let error):
                                      print(error.localizedDescription)
                                  }
                              })
        likeButton.setImage(photo.isLiked ? UIImage(named: "Active"):UIImage(named: "No Active"),
                            for: .normal)
        dateLabel.text = photo.createdAt?.dateString
    }

    
    func getCalculatedHeight(forWidth width: CGFloat) -> CGFloat {
        guard let image = imageCell.image else {
            return 0
        }
        let imageWidth = image.size.width
        let imageViewWidth = width - 8
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + 8
        return cellHeight
    }
}

//MARK: - Cell reuse
extension ImagesListCell{
    override func prepareForReuse() {
        imageCell.kf.cancelDownloadTask()
    }
}
