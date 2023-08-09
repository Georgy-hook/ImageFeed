//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Georgy on 11.06.2023.
//

import UIKit
import Kingfisher
import WebKit

public protocol ProfileViewControllerProtocol{
    var presenter: ProfileViewPresenterProtocol? { get set }
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
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let profileImageService = ProfileImageService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let imageListService = ImagesListService.shared
    var presenter: ProfileViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        
        addSubviews()
        applyConstraints()
        addObserver()
        
        guard let personProfile = profileService.profile else{return}
        
        updateProfileDetails(profile: personProfile)
    }
    
    @objc
    private func didTapButton() {
        ProfileViewController.clean()
        oAuth2TokenStorage.token = nil
        switchToAuthViewController()
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
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(with: url,
                              placeholder: UIImage(named: "Placeholder"),
                              options: [.processor(processor)])
    }
}

//MARK: - Exit methods
extension ProfileViewController{
    private func switchToAuthViewController(){
        let splashScreenViewController = SplashScreenViewController()
        splashScreenViewController.modalPresentationStyle = .fullScreen
        present(splashScreenViewController, animated: true)
    }
    static func clean() {
       // Очищаем все куки из хранилища.
       HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
       // Запрашиваем все данные из локального хранилища.
       WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
          // Массив полученных записей удаляем из хранилища.
          records.forEach { record in
             WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
          }
       }
    
    }
}

//MARK: - ProfileViewControllerProtocol
extension ProfileViewController:ProfileViewControllerProtocol{
    
}
