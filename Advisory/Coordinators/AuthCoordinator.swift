//
//  AuthCoordinator.swift
//  Advisory
//
//  Created by Igor Manakov on 12.11.2022.
//

import UIKit

protocol IAuthCoordinator: AnyObject {
    func showTab()
}

class AuthCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var parentCoordinator: IAppCoordinator
    
    // MARK: - Initialization
    
    init(parentCoordinator: AppCoordinator,
         navigationController: UINavigationController) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
        
        navigationController.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Coordinator
    
    func start() {
        showFirstScene()
    }
    
    func showFirstScene() {
        let assembly = LogInAssembly()
        let controller = assembly.assemble(authCoordinator: self)
        navigationController.pushViewController(controller, animated: true)
    }
}

// MARK: - IAuthCoordinator

extension AuthCoordinator: IAuthCoordinator {
    
    func showTab() {
        parentCoordinator.logIn()
    }
}
