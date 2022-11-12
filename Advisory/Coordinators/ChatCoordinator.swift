//
//  ChatCoordinator.swift
//  Advisory
//
//  Created by Igor Manakov on 12.11.2022.
//

import UIKit

// protocol IPDFCoordinator: AnyObject {
//    func showPDF()
// }
//
// class ChatCoordinator: Coordinator {
//
//    var navigationController: UINavigationController
//    var childCoordinators = [Coordinator]()
//    var parentCoordinator: ITabBarCoordinator
//
//    // MARK: - Initialization
//
//    init(parentCoordinator: ITabBarCoordinator,
//         navigationController: UINavigationController) {
//        self.parentCoordinator = parentCoordinator
//        self.navigationController = navigationController
//
//        navigationController.setNavigationBarHidden(false, animated: true)
//    }
//
//    // MARK: - Coordinator
//
//    func start() {
//        showFirstScene()
//    }
//
//    func showFirstScene() {
//        let assembly = PDFAssembly()
//        let controller = assembly.assemble(chatCoordinator: self)
//        navigationController.pushViewController(controller, animated: true)
//    }
//
//    func showSecondScene() {
//
//    }
// }
//
// // MARK: - IAuthCoordinator
// extension ChatCoordinator: IPDFCoordinator {
//    func showPDF() {
//        showFirstScene()
//    }
// }
