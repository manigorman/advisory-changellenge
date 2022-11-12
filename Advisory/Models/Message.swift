//
//  Message.swift
//  Advisory
//
//  Created by Igor Manakov on 11.11.2022.
//

import MessageKit
import UIKit

// MARK: - ImageMediaItem

private struct ImageMediaItem: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
    
    init(image: UIImage) {
        self.image = image
        size = CGSize(width: 240, height: 240)
        placeholderImage = UIImage()
    }
    
    init(imageURL: URL) {
        url = imageURL
        size = CGSize(width: 240, height: 240)
        placeholderImage = UIImage(imageLiteralResourceName: "image_message_placeholder")
    }
}

// MARK: - MockLinkItem

struct MockLinkItem: LinkItem {
    let text: String?
    let attributedText: NSAttributedString?
    let url: URL
    let title: String?
    let teaser: String
    let thumbnailImage: UIImage
}

// MARK: - MockMessage

internal struct Message: MessageType {
    // MARK: Lifecycle
    
    private init(kind: MessageKind, user: User, messageId: String, date: Date) {
        self.kind = kind
        self.user = user
        self.messageId = messageId
        sentDate = date
    }
    
    /// Widget Message
    init(custom: Any?, user: User, messageId: String, date: Date) {
        self.init(kind: .custom(custom), user: user, messageId: messageId, date: date)
    }
    
    /// Text Message
    init(text: String, user: User, messageId: String, date: Date) {
        self.init(kind: .text(text), user: user, messageId: messageId, date: date)
    }
    
    /// Image Message
    init(image: UIImage, user: User, messageId: String, date: Date) {
        let mediaItem = ImageMediaItem(image: image)
        self.init(kind: .photo(mediaItem), user: user, messageId: messageId, date: date)
    }
    
    /// LinkItem
    init(linkItem: LinkItem, user: User, messageId: String, date: Date) {
        self.init(kind: .linkPreview(linkItem), user: user, messageId: messageId, date: date)
    }
    
    // MARK: Internal
    
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    var user: User
    
    var sender: SenderType {
        user
    }
}
