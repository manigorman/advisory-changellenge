//
//  SignInPresenter.swift
//  Advisory
//
//  Created by Igor Manakov on 12.11.2022.
//

import UIKit

protocol ILogInPresenter: AnyObject {
    func didTapLogIn(login: String, password: String)
}

final class LogInPresenter {
    
    // Dependencies
    weak var view: ILogInView?
    private let networkingService: NetworkingService
    private let coordinator: IAuthCoordinator
    
    // MARK: - Initialization
    
    init(coordinator: IAuthCoordinator,
         networkingService: NetworkingService) {
        self.coordinator = coordinator
        self.networkingService = networkingService
    }
}

// MARK: - ILogInPresenter

extension LogInPresenter: ILogInPresenter {
     
    func didTapLogIn(login: String, password: String) {
        
        view?.shouldActivityIndicatorWorking(true)
        
        Task {
            do {
                let token = try await networkingService.authorize(model: .init(login: login,
                                                                               password: password))
                
                print(token)
                
                await MainActor.run {
                    coordinator.showTab()
                    UserDefaults.standard.set(true, forKey: "IsLoggedIn")
                }
            } catch {
                await MainActor.run {
                    view?.shouldActivityIndicatorWorking(false)
                    view?.showAlert(message: "Произошла ошибка, попробуйте еще раз")
                }
                print(error.localizedDescription)
            }
        }
    }
}
