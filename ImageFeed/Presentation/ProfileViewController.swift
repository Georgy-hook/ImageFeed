//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Georgy on 11.06.2023.
//

import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    @objc
    private func didTapButton() {
        
    }
}

extension ProfileViewController{
    func initialize(){
        //MARK: - Profile ImageView
        let profileImageView: UIImageView = {
            let imageView = UIImageView()
            let profileImage = UIImage(systemName: "person.crop.circle.fill")
            imageView.image = profileImage
            imageView.tintColor = .gray
            return imageView
        }()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: - Name Label
        let nameLabel: UILabel = {
            let label = UILabel()
            label.text = "Name"
            label.font = UIFont.systemFont(ofSize: 23)
            label.textColor = UIColor(named: "YP White")
            return label
        }()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: - Link Label
        let linkLabel: UILabel = {
            let label = UILabel()
            label.text = "@link"
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = UIColor(named: "YP Gray")
            return label
        }()
        linkLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: - Description Label
        let descriptionLabel: UILabel = {
            let label = UILabel()
            label.text = "Hello world"
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = UIColor(named: "YP White")
            return label
        }()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: - Exit Button
        let exitButton: UIButton = {
            let button = UIButton.systemButton(
                with: UIImage(systemName: "ipad.and.arrow.forward")!,
                target: self,
                action: #selector(Self.didTapButton)
            )
            button.tintColor = .red
            return button
        }()
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: - Layout
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(linkLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(exitButton)
 
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            linkLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            linkLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: linkLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
        ])
    }
    
}
