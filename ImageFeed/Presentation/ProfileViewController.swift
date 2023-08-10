//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Georgy on 11.06.2023.
//

import UIKit
import Kingfisher
import WebKit

protocol ProfileViewControllerProtocol:AnyObject{
    var presenter: ProfileViewPresenterProtocol? { get set }
    func switchToAuthViewController()
    func updateProfileDetails(profile: Profile)
}

final class ProfileViewController: UIViewController {
    
    //MARK: - Profile ImageView
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        let profileImage = UIImage(named: "Photo")
        imageView.image = profileImage
        imageView.tintColor = .gray
        return imageView
    }()
    
    //MARK: - Name Label
   private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.font = UIFont.systemFont(ofSize: 23)
        label.textColor = UIColor(named: "YP White")
        return label
    }()
    
    //MARK: - Link Label
    private let linkLabel: UILabel = {
        let label = UILabel()
        label.text = "@ekaterina_nov"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(named: "YP Gray")
        return label
    }()
    
    //MARK: - Description Label
   private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello world"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(named: "YP White")
        return label
    }()
    
    //MARK: - Exit Button
    private let exitButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        button.tintColor = UIColor(named: "YP Red")
        return button
    }()
    
    //MARK: - Variables
    private var profileImageServiceObserver: NSObjectProtocol?
    var presenter: ProfileViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        
        addSubviews()
        applyConstraints()
        addObserver()
        
        presenter?.viewDidLoad()
    }
    
    @objc
    private func didTapButton() {
        presenter?.didExitButtonClicked()
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

//MARK: - Notification center new API
extension ProfileViewController{
    private func addObserver(){
        profileImageServiceObserver = NotificationCenter.default 
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        updateAvatar()
    }
    private func updateAvatar(){
        guard let url = presenter?.getImageUrl() else {return}
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: url,
                              placeholder: UIImage(named: "Placeholder"),
                              options: [.processor(processor)])
    }
}

//MARK: - ProfileViewControllerProtocol
extension ProfileViewController:ProfileViewControllerProtocol{
    
    func updateProfileDetails(profile: Profile){
        nameLabel.text = profile.name
        linkLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    func switchToAuthViewController(){
        let splashScreenViewController = SplashScreenViewController()
        splashScreenViewController.modalPresentationStyle = .fullScreen
        present(splashScreenViewController, animated: true)
    }
}
