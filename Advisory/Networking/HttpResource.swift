//
//  HttpResource.swift
//  Advisory
//
//  Created by Samat Gaynutdinov on 12.11.2022.
//

import Foundation

enum HttpMethodType: String {
    case get = "GET"
    case post = "POST"
}

struct HttpResource<RequestModel: Encodable, ResponseModel: Decodable> {
    let request: URLRequest
    private let httpMethodType: HttpMethodType
    private let baseUrl: URL = URL(string: "https://hack.invest-open.ru")!
    
    init(requestModel: RequestModel?,
         httpMethodType: HttpMethodType,
         headers: [String: String] = [:],
         params: [String: String] = [:],
         path: String,
         token: String? = nil
    ) {
        self.httpMethodType = httpMethodType
        
        var finalHeaders = headers
        if let token {
            finalHeaders["Authorization"] = "Bearer \(token)"
        }
        // TODO: add params to header
        
        self.request = { [baseUrl] in
            let url = baseUrl.appendingPathComponent(path)
            var request = URLRequest(url: url)
            
            if let requestModel {
                request.httpBody = try? JSONEncoder().encode(requestModel)
                finalHeaders["Content-Type"] = "application/json"
            }
            
            request.httpMethod = httpMethodType.rawValue
            request.allHTTPHeaderFields = finalHeaders
            return request
        }()
    }
}
