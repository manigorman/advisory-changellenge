//
//  Message.swift
//  Advisory
//
//  Created by Igor Manakov on 11.11.2022.
//

import Foundation
import MessageKit

struct Message: MessageType {
    public var sender: SenderType
    
    public var messageId: String
    
    public var sentDate: Date
    
    public var kind: MessageKind
}
