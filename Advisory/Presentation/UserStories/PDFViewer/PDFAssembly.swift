//
//  PDFAssembly.swift
//  Advisory
//
//  Created by Igor Manakov on 12.11.2022.
//

import UIKit

final class PDFAssembly {
    
    // MARK: - Public
    
    func assemble() -> UIViewController {
        
        let router = PDFRouter()
        
        let presenter = PDFPresenter(router: router)
        
        let controller = PDFViewController(presenter: presenter)
        
        presenter.view = controller
        router.transitionHandler = controller
        
        return controller
    }
}
