//
//  HistoryMessagesResponseNetworkModel.swift
//  Advisory
//
//  Created by Samat Gaynutdinov on 12.11.2022.
//

struct CachedMessageResponseNetworkModel: Decodable {
    let messageId: String
    let text: String
    let data: String
    let messageType: MessageTypeNetworkModel
    let mediaUrl: String
    let sender: Int
    let recipient: Int
    let dialogId: Int
    let timestamp: Int
}

struct HistoryMessagesResponseNetworkModel: Decodable {
    let messages: [CachedMessageResponseNetworkModel]
}
