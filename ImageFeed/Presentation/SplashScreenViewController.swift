//
//  SplashScreenViewController.swift
//  ImageFeed
//
//  Created by Georgy on 03.07.2023.
//

import UIKit

final class SplashScreenViewController: UIViewController {
    //MARK: - SplashScreen ImageView
    private let splashScreenImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Vector")
        return imageView
    }()
    //MARK: - Varibles
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let errorAlertService = ErrorAlertService.shared
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        addSubviews()
        applyConstraints()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = OAuth2TokenStorage.shared.token{
            fetchProfile(token: token)
            if let profileUsername = profileService.profile?.username {
                fetchProfileImageURL(username: profileUsername, token: token)
            }
        }else{
            switchToAuthViewController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
}
//MARK: - Layout
private extension SplashScreenViewController{
    func applyConstraints(){
        splashScreenImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            splashScreenImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashScreenImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    func addSubviews(){
        view.addSubview(splashScreenImageView)
    }
}
//MARK: - Navigation
private extension SplashScreenViewController {
    
    private func switchToAuthViewController(){
        let authViewController = AuthViewController()
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = TabBarController()
        window.rootViewController = tabBarController
    }
}

//MARK: - AuthViewControllerDelegate
extension SplashScreenViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    private func fetchOAuthToken(_ code: String) {
        OAuth2Service.shared.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                OAuth2TokenStorage.shared.token = token
                self.fetchProfile(token: token)
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print(error)
                self.errorAlertService.showAlert(on: self, with: .networkError)
                break
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                UIBlockingProgressHUD.dismiss()
                self.fetchProfileImageURL(username: profile.username, token: token)
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.errorAlertService.showAlert(on: self, with: .networkError)
                break
            }
        }
    }
    private func fetchProfileImageURL(username: String, token: String){
        profileImageService.fetchProfileImageURL(username: username , token){result in
            switch result {
            case .success(let url):
                return
            case .failure(let error):
                print(error)
            }
        }
    }
}
