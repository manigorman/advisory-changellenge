//
//  File.swift
//  Advisory
//
//  Created by Igor Manakov on 12.11.2022.
//

import UIKit

protocol IPDFRouter: AnyObject {
    func dismiss()
}

final class PDFRouter: IPDFRouter {
    
    // MARK: - Dependencies
    
    weak var transitionHandler: UIViewController?
    
    // MARK: - IPDFRouter
    
    func dismiss() {
        transitionHandler?.dismiss(animated: true)
    }
}
