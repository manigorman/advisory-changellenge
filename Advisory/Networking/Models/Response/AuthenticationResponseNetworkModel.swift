//
//  AuthenticationResponseNetworkModel.swift
//  Advisory
//
//  Created by Samat Gaynutdinov on 12.11.2022.
//

struct AuthenticationResponseNetworkModel: Decodable {
    let userId: Int
    let login: String
    let role: String
    let jwtToken: String
}
