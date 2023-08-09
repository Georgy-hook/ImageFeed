//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Georgy on 08.08.2023.
//

import UIKit
import WebKit

public protocol ProfileViewPresenterProtocol{
    var view: ProfileViewControllerProtocol? { get set }
    func didExitButtonClicked()
    func viewDidLoad()
    func getImageUrl() -> URL?
}

final class ProfileViewPresenter:ProfileViewPresenterProtocol {
    // MARK: - Variables
    var view: ProfileViewControllerProtocol?
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    // MARK: - ProfileViewPresenterProtocol
    func didExitButtonClicked(){
        ProfileViewPresenter.clean()
        oAuth2TokenStorage.token = nil
        view?.switchToAuthViewController()
    }
    static func clean() {
       // Очищаем все куки из хранилища.
       HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
       // Запрашиваем все данные из локального хранилища.
       WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
          // Массив полученных записей удаляем из хранилища.
          records.forEach { record in
             WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
          }
       }
    }
    
    func viewDidLoad() {
        guard let personProfile = profileService.profile else{return}
        
        view?.updateProfileDetails(profile: personProfile)
    }
    
    func getImageUrl() -> URL?{
        guard
            let profileImageURL = profileImageService.avatarURL,
            let url = URL(string: profileImageURL)
        else { return nil }
        return url
    }
}
