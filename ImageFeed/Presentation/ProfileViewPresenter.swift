//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Georgy on 08.08.2023.
//

import Foundation

public protocol ProfileViewPresenterProtocol{
    var view: ProfileViewControllerProtocol? { get set }
}

final class ProfileViewPresenter:ProfileViewPresenterProtocol {
    // MARK: - Variables
    var view: ProfileViewControllerProtocol?
    
    
    // MARK: - ProfileViewPresenterProtocol
    
}
