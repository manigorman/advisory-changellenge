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
        
        let presenter = LogInPresenter(coordinator: authCoordinator)
        
        let controller = LogInViewController(presenter: presenter)
        
        presenter.view = controller
        
        return controller
    }
}
