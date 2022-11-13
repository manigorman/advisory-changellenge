//
//  AppCoordinator.swift
//  Advisory
//
//  Created by Igor Manakov on 11.11.2022.
//

import UIKit

protocol IAppCoordinator: AnyObject {
    func logIn()
}

final class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "IsLoggedIn")
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Coordinator
    
    func start() {
        if isLoggedIn {
            showTab()
        } else {
            showAuth()
        }
    }
    
    func showAuth() {
        let authCoordinator = AuthCoordinator(parentCoordinator: self,
                                              navigationController: navigationController)
        authCoordinator.start()
        childCoordinators.append(authCoordinator)
    }
    
    func showTab() {
        let tabCoordinator = TabBarCoordinator(parentCoordinator: self,
                                               navigationController: navigationController)
        tabCoordinator.start()
        childCoordinators.append(tabCoordinator)
    }
}

// MARK: - IAppCoordinator

extension AppCoordinator: IAppCoordinator {
    
    func logIn() {
        navigationController.viewControllers.removeAll()
        for coordinator in childCoordinators {
            coordinator.finish()
        }
        showTab()
    }
}
