//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Georgy on 28.06.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    
    //MARK: - Varibles
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    var delegate: AuthViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

//MARK: - Segue
extension AuthViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier{
            let viewController = segue.destination as! WebViewViewController
            viewController.delegate = self
        } else{
            super.prepare(for: segue, sender: sender)
        }
    }
}
