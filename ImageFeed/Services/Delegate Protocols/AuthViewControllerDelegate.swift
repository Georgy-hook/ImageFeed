//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Georgy on 03.07.2023.
//

import Foundation
protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
