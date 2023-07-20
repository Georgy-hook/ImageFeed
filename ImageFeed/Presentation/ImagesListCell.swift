//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Georgy on 28.05.2023.
//

import UIKit

class ImagesListCell: UITableViewCell {

    //MARK: - Variables
    static let reuseIdentifier = "ImagesListCell"

    enum likeButtonState{
        case active
        case inactive
    }
    //MARK: - UI Elements
   private let imageCell: UIImageView = {
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
extension ImagesListCell{
    func switchLikeButtonState(to state: likeButtonState){
        switch state{
        case .active:
            likeButton.setImage(UIImage(named: "Active"), for: .normal)
        case .inactive:
            likeButton.setImage(UIImage(named: "No Active"), for: .normal)
        }
    }
    func configure(with indexPath:IndexPath){
        imageCell.image = UIImage(named: "\(indexPath.row)")
        dateLabel.text = Date().dateString
    }
}
