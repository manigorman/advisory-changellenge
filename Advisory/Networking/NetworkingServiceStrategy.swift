//
//  NetworkingServiceStrategy.swift
//  Advisory
//
//  Created by Samat Gaynutdinov on 12.11.2022.
//

import Foundation

final class NetworkingServiceStrategy {
    func performNetworkRequest<RequestModel: Encodable, ResponseModel: Decodable>(with resource: HttpResource<RequestModel, ResponseModel>) async throws -> ResponseModel {
        let (data, response) = try await URLSession.shared.data(for: resource.request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.notHttp
        }
        
        guard response.statusCode == 200 else {
            throw NetworkError.someErrror
        }
        
        guard let model = try? JSONDecoder().decode(ResponseModel.self, from: data) else {
            throw NetworkError.jsonDecode
        }
        
        return model
    }
    
    func performNetworkRequestWithoutResponseModel<RequestModel: Encodable>(with resource: HttpResource<RequestModel, Never>) async throws {
        let (_, response) = try await URLSession.shared.data(for: resource.request)

        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.notHttp
        }
        
        guard response.statusCode == 200 else {
            throw NetworkError.someErrror
        }
    }
}

enum NetworkError: Error {
    case someErrror
    case jsonDecode
    case notHttp
}
