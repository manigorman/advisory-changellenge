//
//  ChatAssembly.swift
//  Advisory
//
//  Created by Igor Manakov on 11.11.2022.
//

import UIKit

final class ChatAssembly {
    
    // MARK: - Public
    
    func assemble() -> UIViewController {
        
        let router = ChatRouter()
        
        let networkingService = NetworkingService()
        
        let presenter = ChatPresenter(router: router,
        networkingService: networkingService)
        
        let controller = ChatViewController(presenter: presenter)
        
        presenter.view = controller
        router.transitionHandler = controller
        
        return controller
    }
}
