//
//  SignInPresenter.swift
//  Advisory
//
//  Created by Igor Manakov on 12.11.2022.
//

import UIKit

protocol ILogInPresenter: AnyObject {
    func viewDidLoad()
    func didTapLogIn(email: String, password: String)
}

final class LogInPresenter {
    
    // Dependencies
    weak var view: ILogInView?
    
    private let coordinator: IAuthCoordinator
    
    // Private
    
    // Models
    
    // MARK: - Initialization
    
    init(coordinator: IAuthCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Private
}

// MARK: - ILogInPresenter

extension LogInPresenter: ILogInPresenter {
    
    func viewDidLoad() {
    }
     
    func didTapLogIn(email: String, password: String) {
//        guard validationService.isValid(email, type: .email),
//              validationService.isValid(password, type: .password) else {
//            view?.showAlert(message: "Wrong email or password")
//            return
//        }
        
        view?.shouldActivityIndicatorWorking(true)
        coordinator.showTab()
    }
}
