//
//  MessageNetworkModel.swift
//  Advisory
//
//  Created by Samat Gaynutdinov on 12.11.2022.
//

struct MessageNetworkModel: Encodable {
    let dialogId: Int
    let text: String
    let messageType: MessageTypeNetworkModel
    let data: String?
    let mediaUrl: String?
}
