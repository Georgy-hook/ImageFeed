//
//  SplashScreenViewController.swift
//  ImageFeed
//
//  Created by Georgy on 03.07.2023.
//

import UIKit
import ProgressHUD

final class SplashScreenViewController: UIViewController {
    //MARK: - Varibles
    private let ShowAuthViewSegueIdentifier = "ShowAuthView"
    private let ShowImageListViewSegueIdentifier = "ShowImageListView"
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let errorAlertService = ErrorAlertService.shared
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = OAuth2TokenStorage.shared.token{
            fetchProfile(token: token)
            //switchToTabBarController()
            if let profileUsername = profileService.profile?.username {
                fetchProfileImageURL(username: profileUsername, token: token)
            }
        }else{
            performSegue(withIdentifier: ShowAuthViewSegueIdentifier, sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

//MARK: - Segue
extension SplashScreenViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthViewSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(ShowAuthViewSegueIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
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
                errorAlertService.showAlert(on: self, with: .networkError)
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
                fetchProfileImageURL(username: profile.username, token: token)
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                errorAlertService.showAlert(on: self, with: .networkError)
                break
            }
        }
    }
    private func fetchProfileImageURL(username: String, token: String){
        profileImageService.fetchProfileImageURL(username: username , token){ [weak self] result in
      //      guard let self = self else { return }
            switch result {
            case .success(let url):
                print(url)
            case .failure(let error):
                print(error)
            }
        }
    }
}
