//
//  TabBarAssembly.swift
//  Advisory
//
//  Created by Igor Manakov on 11.11.2022.
//

import UIKit

final class TabBarAssembly {
    
    // MARK: - Public
    
    func assemble() -> UIViewController {
        let presenter = TabBarPresenter()
        
        let controller = TabBarViewController(presenter: presenter)
        
        let chatsVC = createNavController(with: ChatAssembly().assemble(),
                                         selected: UIImage(systemName: "message.fill"),
                                         unselected: UIImage(systemName: "message"),
                                         title: "Chat")

        controller.setControllers([chatsVC], animated: false)
        
        presenter.view = controller
        
        return controller
    }
    
    func createNavController(with vc: UIViewController, selected: UIImage?, unselected: UIImage?, title: String) -> UINavigationController {
        let viewController = vc
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselected
        navController.tabBarItem.selectedImage = selected
        navController.title = title
        navController.navigationBar.prefersLargeTitles = true
        
        return navController
    }
}
