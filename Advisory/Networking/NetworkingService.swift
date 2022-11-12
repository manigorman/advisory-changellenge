//
//  NetworkingService.swift
//  Advisory
//
//  Created by Samat Gaynutdinov on 12.11.2022.
//

import Foundation

actor NetworkingService {
    private var token: String = ""
    
    private let networkCaller = NetworkingServiceStrategy()
    
    func changeToken(_ token: String) {
        self.token = token
    }
    
    // MARK: - API
    func sendMessage(model: SendMessageRequestNetworkModel) async throws -> SendMessageResponseNetworkModel {
        
        let resource = HttpResource<SendMessageRequestNetworkModel, SendMessageResponseNetworkModel>(requestModel: model, httpMethodType: .post, path: "message/send", token: token)
        
        return try await networkCaller.performNetworkRequest(with: resource)
    }
    
    func authorize(model: AuthenticationRequestNetworkModel) async throws -> AuthenticationResponseNetworkModel {
        
        let encryptedModel = AuthenticationRequestNetworkModel(login: model.login, password: model.password.sha256())

        let resource = HttpResource<AuthenticationRequestNetworkModel, AuthenticationResponseNetworkModel>(
            requestModel: encryptedModel,
            httpMethodType: .post,
            path: "auth"
        )
        
        let responseModel = try await networkCaller.performNetworkRequest(with: resource)
        
        token = responseModel.jwtToken
        return responseModel
    }
    
    func getMessages(model: HistoryMessagesRequestNetworkModel) async throws -> HistoryMessagesResponseNetworkModel {
        let resource = HttpResource<HistoryMessagesRequestNetworkModel, HistoryMessagesResponseNetworkModel>(
            requestModel: model,
            httpMethodType: .get,
            params: [
                "dialogId": "1",
                "limit": "1"
            ],
            path: "chat/history",
            token: token,
            shouldUseParams: true
        )
        
        return try await networkCaller.performNetworkRequest(with: resource)
    }
    
    func getDialog() async throws -> GetDialogResponseNetworkModel {
        let resource = HttpResource<Dummy, GetDialogResponseNetworkModel>(
            requestModel: nil,
            httpMethodType: .get,
            path: "chat/dialog",
            token: token
        )
        
        return try await networkCaller.performNetworkRequest(with: resource)
    }
    
    func changeWidget(_ model: ChangeWidgetRequestNetworkModel) async throws {
        let resource = HttpResource<ChangeWidgetRequestNetworkModel, Never>(
            requestModel: model,
            httpMethodType: .post,
            path: "chat/message/update",
            token: token
        )
        
        try await networkCaller.performNetworkRequestWithoutResponseModel(with: resource)
    }
}
