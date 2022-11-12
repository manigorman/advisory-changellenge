//
//  ChatPresenter.swift
//  Advisory
//
//  Created by Igor Manakov on 11.11.2022.
//

import UIKit

protocol IChatPresenter: AnyObject {
    func viewDidLoad()
    func didTapPDF()
}

final class ChatPresenter {
    
    // Dependencies
    private let router: IChatRouter
    
    weak var view: IChatView?
    
    // UI
    
    // Private
    
    // MARK: - Initialization
    
    init(router: IChatRouter) {
        self.router = router
    }
    
}

// IConversationPresenter

extension ChatPresenter: IChatPresenter {
    func viewDidLoad() {
    }
    
    func didTapPDF() {
        router.showPDF()
    }
}
