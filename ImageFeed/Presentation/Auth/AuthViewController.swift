//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Georgy on 28.06.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    //MARK: - Views
    private let UnsplashImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo_of_Unsplash")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let webViewButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.setTitleColor(UIColor(named: "YP Black"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(named: "YP White")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(presentWebView), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Variables
    var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        addSubviews()
        applyConstraints()
    }
    
    @objc private func presentWebView() {
        let webVC = WebViewViewController()
        let authHelper = AuthHelper()
        let webViewPresenter = WebViewPresenter(authHelper: authHelper)
        
        webViewPresenter.view = webVC
        webVC.presenter = webViewPresenter
        webVC.delegate = self
        
        webVC.modalPresentationStyle = .fullScreen
        self.present(webVC, animated: true)
    }
}

// MARK: - Layout
private extension AuthViewController{
    func addSubviews() {
        view.addSubview(UnsplashImageView)
        view.addSubview(webViewButton)
    }
    func applyConstraints() {
        NSLayoutConstraint.activate([
            UnsplashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            UnsplashImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            UnsplashImageView.widthAnchor.constraint(equalToConstant: 60),
            UnsplashImageView.heightAnchor.constraint(equalToConstant: 60),
            
            webViewButton.topAnchor.constraint(equalTo: UnsplashImageView.bottomAnchor, constant: 204),
            webViewButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            webViewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            webViewButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}

//MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate{
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}
extension AuthViewController{
    override var preferredStatusBarStyle: UIStatusBarStyle{
        .lightContent
    }
}
