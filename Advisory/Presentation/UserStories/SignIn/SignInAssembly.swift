//
//  SignInAssembly.swift
//  Advisory
//
//  Created by Igor Manakov on 12.11.2022.
//

import UIKit

final class LogInAssembly {
    
    // MARK: - Public
    
    func assemble(authCoordinator: AuthCoordinator) -> UIViewController {
        
        let networkingService = NetworkingService()
        
        let presenter = LogInPresenter(coordinator: authCoordinator,
        networkingService: networkingService)
        
        let controller = LogInViewController(presenter: presenter)
        
        presenter.view = controller
        
        return controller
    }
}
