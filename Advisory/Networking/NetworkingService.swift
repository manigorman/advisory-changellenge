//
//  NetworkingService.swift
//  Advisory
//
//  Created by Samat Gaynutdinov on 12.11.2022.
//

import Foundation

actor NetworkingService {
    static private var token: String = ""
    
    private let networkCaller = NetworkingServiceStrategy()
    
    func changeToken(_ token: String) {
        Self.token = token
    }
    
    // MARK: - API
    @discardableResult
    func sendMessage(model: SendMessageRequestNetworkModel) async throws -> SendMessageResponseNetworkModel {
        
        let resource = HttpResource<SendMessageRequestNetworkModel,
                                    SendMessageResponseNetworkModel>(requestModel: model,
                                                                     httpMethodType: .post,
                                                                     path: "message/send",
                                                                     token: Self.token)
        
        return try await networkCaller.performNetworkRequest(with: resource)
    }
    
    @discardableResult
    func authorize(model: AuthenticationRequestNetworkModel) async throws -> AuthenticationResponseNetworkModel {
        
        let encryptedModel = AuthenticationRequestNetworkModel(login: model.login, password: model.password.sha256())

        let resource = HttpResource<AuthenticationRequestNetworkModel, AuthenticationResponseNetworkModel>(
            requestModel: encryptedModel,
            httpMethodType: .post,
            path: "auth"
        )
        
        let responseModel = try await networkCaller.performNetworkRequest(with: resource)
        
        changeToken(responseModel.jwtToken)
        return responseModel
    }
    
    func getMessages(model: HistoryMessagesRequestNetworkModel, params: [String: String] = [:]) async throws -> HistoryMessagesResponseNetworkModel {
        let resource = HttpResource<HistoryMessagesRequestNetworkModel, HistoryMessagesResponseNetworkModel>(
            requestModel: model,
            httpMethodType: .get,
            params: params,
            path: "chat/history",
            token: Self.token,
            shouldUseParams: true
        )
        
        return try await networkCaller.performNetworkRequest(with: resource)
    }
    
    func getDialog() async throws -> GetDialogResponseNetworkModel {
        let resource = HttpResource<Dummy, GetDialogResponseNetworkModel>(
            requestModel: nil,
            httpMethodType: .get,
            path: "chat/dialog",
            token: Self.token
        )
        
        print(Self.token)
        
        return try await networkCaller.performNetworkRequest(with: resource)
    }
    
    func changeWidget(_ model: ChangeWidgetRequestNetworkModel) async throws {
        let resource = HttpResource<ChangeWidgetRequestNetworkModel, Never>(
            requestModel: model,
            httpMethodType: .post,
            path: "chat/message/update",
            token: Self.token
        )
        
        try await networkCaller.performNetworkRequestWithoutResponseModel(with: resource)
    }
}
