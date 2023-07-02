//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Georgy on 28.06.2023.
//

import UIKit

class AuthViewController: UIViewController {
    
    //MARK: - Varibles
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
}
//MARK: - WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate{
    
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        OAuth2Service.shared.fetchOAuthToken(code){
            
        }
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
