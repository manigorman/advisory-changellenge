//
//  ChatViewController.swift
//  Advisory
//
//  Created by Igor Manakov on 11.11.2022.
//

import UIKit
import MessageKit

extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text:
            return "text"
        case .attributedText:
            return "attributed_text"
        case .photo:
            return "photo"
        case .video:
            return "video"
        case .location:
            return "locatio"
        case .emoji:
            return "emoji"
        case .audio:
            return "audio"
        case .contact:
            return "contact"
        case .linkPreview:
            return "link_preview"
        case .custom:
            return "custom"
        }
    }
}

protocol IChatView: AnyObject {
    
}

final class ChatViewContoller: MessagesViewController {
    
    // Dependencies
    private let presenter: IChatPresenter
    
    // Private
    private var messages: [Message] = [.init(sender: Sender(photoURL: "",
                                                            senderId: "",
                                                            displayName: "Ivan"),
                                             messageId: "dhsafgshajdkfjhasdfjkhsajkdfhkjasdfhjkadshjf",
                                             sentDate: Date(),
                                             kind: .text("fasdfaf"))]
    
    // UI
    
    // MARK: - Initialization
    
    init(presenter: IChatPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        
        setUpUI()
        setUpConstraints()
        setUpDelegates()
    }
    
    // MARK: - Actions
    
    // MARK: - Private
    
    private func setUpUI() {
        view.backgroundColor = .systemBackground
    }
    
    private func setUpConstraints() {
        
    }
    
    private func setUpDelegates() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
}

// MARK: - IConversationView

extension ChatViewContoller: IChatView {
    
}

// MARK: - MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate

extension ChatViewContoller: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        return Sender(photoURL: "", senderId: "12", displayName: "Igor")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.row]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        messages.count
    }
}
