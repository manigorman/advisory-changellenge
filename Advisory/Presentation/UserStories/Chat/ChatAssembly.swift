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
        
        let presenter = ChatPresenter()
        
        let controller = ChatViewContoller(presenter: presenter)
        
        presenter.view = controller
        
        return controller
    }
    
}
