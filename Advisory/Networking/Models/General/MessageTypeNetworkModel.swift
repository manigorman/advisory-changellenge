//
//  MessageTypeNetworkModel.swift
//  Advisory
//
//  Created by Samat Gaynutdinov on 12.11.2022.
//

enum MessageTypeNetworkModel: Codable {
    case text
    case media
    case widget
    
    enum CodingKeys: String, CodingKey {
        case text = "TEXT"
        case media = "MEDIA"
        case widget = "WIDGET"
    }
}
