//
//  UIViewController+Alert.swift
//  Advisory
//
//  Created by Igor Manakov on 13.11.2022.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alertInfoError(message: String = "Пожалуйста, проверьте правильность заполения полей") {
        let alert = UIAlertController(title: "Ошибка",
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "ОК",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
    }
}
