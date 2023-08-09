//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Georgy on 28.06.2023.
//

import UIKit
import WebKit

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController, WKNavigationDelegate {
    // MARK: - Views
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.setImage(UIImage(named: "nav_back_button"), for: .normal)
        button.tintColor = UIColor(named: "YP Black")
        return button
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = UIColor(named: "YP Black")
        return progressView
    }()
    
    // MARK: - Variables
    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    var presenter: WebViewPresenterProtocol?
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "YP White")
        
        addSubviews()
        applyConstraints()
        
        presenter?.viewDidLoad()
        
        webView.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 presenter?.didUpdateProgressValue(webView.estimatedProgress)
             })
    }
    
    // MARK: - Actions
    @objc private func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    // MARK: - WKNavigationDelegate
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let code = code(from: navigationAction) {
                delegate?.webViewViewController(self, didAuthenticateWithCode: code)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }
}

// MARK: - Layout
private extension WebViewViewController {
    func addSubviews() {
        view.addSubview(webView)
        view.addSubview(progressView)
        view.addSubview(backButton)
    }
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: backButton.bottomAnchor)
        ])
    }
}
// MARK: - Preferred Status Bar
extension WebViewViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

// MARK: - WebViewViewControllerProtocol
extension WebViewViewController:WebViewViewControllerProtocol{
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
}
