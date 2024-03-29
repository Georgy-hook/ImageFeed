//
//  ErrorAlertService.swift
//  ImageFeed
//
//  Created by Georgy on 10.07.2023.
//

import Foundation
import UIKit

enum UserError: String, Error {
    case userNotFound = "Пользователь не найден"
    case wrongPassword = "Неверный пароль"
    case networkError = "Не удалось войти в систему"
    case unknownError = "Неизвестная ошибка"
    
    var localizedDescription: String {
        return self.rawValue
    }
}

final class ErrorAlertService {
    static let shared = ErrorAlertService()
    private init() {}

    func showAlert(on viewController: UIViewController, with error: UserError, okHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "Что-то пошло не так", message: error.localizedDescription, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "ОК", style: .default){_ in 
            okHandler()
        }
        
        alert.addAction(okAction)
        
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func showErrorAlert(on viewController: UIViewController, retryHandler: @escaping () -> Void) {
         let alert = UIAlertController(title: "Что-то пошло не так", message: "Попробовать ещё раз?", preferredStyle: .alert)

         let repeatAction = UIAlertAction(title: "Повторить", style: .default) { _ in
             retryHandler()
         }
         let cancelAction = UIAlertAction(title: "Не надо", style: .cancel, handler: nil)

         alert.addAction(repeatAction)
         alert.addAction(cancelAction)
         
         viewController.present(alert, animated: true, completion: nil)
     }
}
