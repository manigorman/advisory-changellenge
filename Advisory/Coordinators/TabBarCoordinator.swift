//
//  TabBarCoordinator.swift
//  Advisory
//
//  Created by Igor Manakov on 11.11.2022.
//

import UIKit

protocol ITabBarCoordinator: AnyObject {
    
}

final class TabBarCoordinator: Coordinator {
    var parentCoordinator: IAppCoordinator
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    // MARK: - Initialization
    init(parentCoordinator: AppCoordinator,
         navigationController: UINavigationController) {
        self.parentCoordinator = parentCoordinator
        self.navigationController = navigationController
        
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Coordinator
    
    func start() {
        showFirstScene()
    }
    
    func showFirstScene() {
        let assembly = TabBarAssembly()
        let controller = assembly.assemble()
        navigationController.viewControllers = [controller]
    }
}
