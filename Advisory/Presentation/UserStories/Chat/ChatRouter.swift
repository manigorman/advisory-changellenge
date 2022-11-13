//
//  ChatRouter.swift
//  Advisory
//
//  Created by Igor Manakov on 12.11.2022.
//

import UIKit

protocol IChatRouter: AnyObject {
    func showPDF(with url: URL)
}

final class ChatRouter: IChatRouter {
    
    // MARK: - Dependencies
    
    weak var transitionHandler: UIViewController?
    
    // MARK: - IPDFRouter
    
    func showPDF(with url: URL) {
        let assembly = PDFAssembly()
        let controller = assembly.assemble(url: url)
        transitionHandler?.navigationController?.pushViewController(controller, animated: true)
    }
}
