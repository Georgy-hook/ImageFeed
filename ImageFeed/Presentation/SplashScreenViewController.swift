//
//  SplashScreenViewController.swift
//  ImageFeed
//
//  Created by Georgy on 03.07.2023.
//

import UIKit

class SplashScreenViewController: UIViewController {
    //MARK: - Varibles
    private let ShowAuthViewSegueIdentifier = "ShowAuthView"
    private let ShowImageListViewSegueIdentifier = "ShowImageListView"
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = OAuth2TokenStorage.shared.token{
            switchToTabBarController()
            //performSegue(withIdentifier: ShowImageListViewSegueIdentifier, sender: nil)
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
        // Проверим, что переходим на авторизацию
        if segue.identifier == ShowAuthViewSegueIdentifier {
            
            // Доберёмся до первого контроллера в навигации. Мы помним, что в программировании отсчёт начинается с 0?
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(ShowAuthViewSegueIdentifier)") }
            
            // Установим делегатом контроллера наш SplashViewController
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

//MARK: - AuthViewControllerDelegate
extension SplashScreenViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        OAuth2Service.shared.fetchOAuthToken(code){[weak self] result in
            guard let self = self else { return }
            switch result{
            case .success(let token):
                OAuth2TokenStorage.shared.token = token
                self.switchToTabBarController()
            case .failure(let error):
                print(error)
            }
        }
    }
}
