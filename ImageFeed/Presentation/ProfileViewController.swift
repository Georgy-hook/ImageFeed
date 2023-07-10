//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Georgy on 11.06.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    //MARK: - Profile ImageView
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        let profileImage = UIImage(named: "Photo")
        imageView.image = profileImage
        imageView.tintColor = .gray
        return imageView
    }()
    
    //MARK: - Name Label
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23)
        label.textColor = UIColor(named: "YP White")
        return label
    }()
    
    //MARK: - Link Label
    let linkLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(named: "YP Gray")
        return label
    }()
    
    //MARK: - Description Label
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello world"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(named: "YP White")
        return label
    }()
    
    //MARK: - Exit Button
    let exitButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: ProfileViewController.self,
            action: #selector(Self.didTapButton)
        )
        button.tintColor = UIColor(named: "YP Red")
        return button
    }()
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileImageService = ProfileImageService.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        applyConstraints()
        addObserver()
        guard let personProfile = profileService.profile else{return}
        updateProfileDetails(profile: personProfile)
    }
    
    @objc
    private func didTapButton() {
        
    }
}

extension ProfileViewController{
    
    func  applyConstraints(){
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        linkLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: - Layout
        NSLayoutConstraint.activate([
            profileImageView.heightAnchor.constraint(equalToConstant: 70),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            linkLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            linkLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: linkLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            exitButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            
        ])
    }
    
    func addSubviews(){
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(linkLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(exitButton)
    }
    
}
//MARK: - Preferred Status Bar
extension ProfileViewController{
    override var preferredStatusBarStyle: UIStatusBarStyle{
        .lightContent
    }
}

//MARK: - Profile information fill
extension ProfileViewController{
    func updateProfileDetails(profile: Profile){
        nameLabel.text = profile.name
        linkLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
}

//MARK: - Notification center new API
extension ProfileViewController{
    private func addObserver(){
        profileImageServiceObserver = NotificationCenter.default 
            .addObserver(
                forName: ProfileImageService.DidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    private func updateAvatar(){
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
    }
}
