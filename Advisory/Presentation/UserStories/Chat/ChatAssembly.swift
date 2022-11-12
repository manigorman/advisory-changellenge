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
        
        let presenter = ChatPresenter(router: router)
        
        let controller = ChatViewController(presenter: presenter)
        
        presenter.view = controller
        router.transitionHandler = controller
        
        return controller
    }
    
}
