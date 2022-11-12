//
//  HistoryMessagesRequestNetworkModel.swift
//  Advisory
//
//  Created by Samat Gaynutdinov on 12.11.2022.
//

import Foundation

struct HistoryMessagesRequestNetworkModel: Encodable {
    let dialogId: Int
    let limit: Int?
    let timestamp: Int? = nil
    let older: String? = nil
}
