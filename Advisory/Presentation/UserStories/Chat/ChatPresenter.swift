//
//  ChatPresenter.swift
//  Advisory
//
//  Created by Igor Manakov on 11.11.2022.
//

import UIKit

protocol IChatPresenter: AnyObject {
    func viewDidLoad()
}

final class ChatPresenter {
    
    // Dependencies
    weak var view: IChatView?
    
    // Private
    
    // MARK: - Initialization
    
    init() {
    }
        
}

// IConversationPresenter

extension ChatPresenter: IChatPresenter {
    func viewDidLoad() {
    }
}
