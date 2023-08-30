//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Georgy on 13.07.2023.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.isTranslucent = false
        self.tabBar.barTintColor = UIColor(named: "YP Black")
        self.tabBar.tintColor = UIColor(named: "YP White")
        self.tabBar.unselectedItemTintColor = UIColor(named: "YP White")
        
        let imagesListViewController = ImagesListViewController()
        let imagesListPresenter = ImagesListPresenter()
        imagesListPresenter.view = imagesListViewController
        imagesListViewController.presenter = imagesListPresenter
        
        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_editorial_active"),
            selectedImage: nil
        )
        
        let profileViewPresenter = ProfileViewPresenter()
        let profileViewController = ProfileViewController()
        profileViewPresenter.view = profileViewController
        profileViewController.presenter = profileViewPresenter
        
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        
        self.viewControllers = [imagesListViewController, profileViewController]
    }
}
