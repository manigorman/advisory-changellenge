//
//  User.swift
//  Advisory
//
//  Created by Igor Manakov on 11.11.2022.
//

import Foundation
import MessageKit

struct User: SenderType, Equatable {
    let senderId: String
    let displayName: String
}
