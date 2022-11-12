//
//  ChatRouter.swift
//  Advisory
//
//  Created by Igor Manakov on 12.11.2022.
//

import UIKit

protocol IChatRouter: AnyObject {
    func showPDF()
}

final class ChatRouter: IChatRouter {
    
    // MARK: - Dependencies
    
    weak var transitionHandler: UIViewController?
    
    // MARK: - IPDFRouter
    
    func showPDF() {
        let assembly = PDFAssembly()
        let controller = assembly.assemble()
        transitionHandler?.navigationController?.pushViewController(controller, animated: true)
    }
}
