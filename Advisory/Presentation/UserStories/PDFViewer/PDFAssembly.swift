//
//  PDFAssembly.swift
//  Advisory
//
//  Created by Igor Manakov on 12.11.2022.
//

import UIKit

final class PDFAssembly {
    
    // MARK: - Public
    
    func assemble(url: URL) -> UIViewController {
        
        let router = PDFRouter()
        
        let presenter = PDFPresenter(router: router, url: url)
        
        let controller = PDFViewController(presenter: presenter)
        
        presenter.view = controller
        router.transitionHandler = controller
        
        return controller
    }
}
