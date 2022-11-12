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
    private let networkingService: NetworkingService
    private let coordinator: IAuthCoordinator
    
    // Private
    
    // Models
    
    // MARK: - Initialization
    
    init(coordinator: IAuthCoordinator,
         networkingService: NetworkingService) {
        self.coordinator = coordinator
        self.networkingService = networkingService
    }
    
    // MARK: - Private
}

// MARK: - ILogInPresenter

extension LogInPresenter: ILogInPresenter {
    
    func viewDidLoad() {
    }
     
    func didTapLogIn(email: String, password: String) {
        
        view?.shouldActivityIndicatorWorking(true)
        
        Task {
            do {
                let token = try await networkingService.authorize(model: .init(login: email, password: password))
                
                print(token)
                
                await MainActor.run {
                    coordinator.showTab()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
