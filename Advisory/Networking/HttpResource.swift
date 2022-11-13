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

protocol Resource {
    associatedtype RequestModel
    associatedtype ResponseModel
}

struct HttpResource<RequestModel: Encodable, ResponseModel>: Resource {
    
    typealias RequestModel = RequestModel
    typealias ResponseModel = ResponseModel
    
    let request: URLRequest
    private let httpMethodType: HttpMethodType
    private let baseUrl: URL = URL(string: "https://hack.invest-open.ru")!
    
    init(requestModel: RequestModel?,
         httpMethodType: HttpMethodType,
         headers: [String: String] = [:],
         params: [String: String] = [:],
         path: String,
         token: String? = nil,
         shouldUseParams: Bool = false
    ) {
        self.httpMethodType = httpMethodType
        
        var finalHeaders = headers
        if let token = token {
            finalHeaders["Authorization"] = "Bearer \(token)"
        }
        
        self.request = { [baseUrl] in
            let url = baseUrl.appendingPathComponent(path)
            var request = URLRequest(url: url)
            
            if let requestModel = requestModel {
                if shouldUseParams {
                    var components = URLComponents()
                    components.scheme = "https"
                    components.host = "hack.invest-open.ru"
                    components.path = "/" + path
                    
                    components.queryItems = params.map { (key, value) in
                        URLQueryItem(name: key, value: value)
                    }
                    
                    let compUrl = components.url!
                    request = URLRequest(url: compUrl)
                } else {
                    request.httpBody = try? JSONEncoder().encode(requestModel)
                    finalHeaders["Content-Type"] = "application/json"
                }
            }
            
            request.httpMethod = httpMethodType.rawValue
            request.allHTTPHeaderFields = finalHeaders
            return request
        }()
    }
}
