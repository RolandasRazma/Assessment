//
//  APIClientProtocol.swift
//  APIClient
//
//  Created by Rolandas Razma on 27/12/2021.
//

import Foundation
import Alamofire

public protocol APIClientProtocol {
    
    var baseURL: URL { get }
    
    func request<T: Decodable>(_ request: RequestProtocol) async throws -> T
    
}

public extension APIClientProtocol {
    
    func request<T: Decodable>(_ request: RequestProtocol) async throws -> T {
        return try await AF.request(baseURL.appendingPathComponent(request.path), method: request.method)
            .validate(statusCode: 200..<300)
            .serializingDecodable(T.self)
            .value
    }
    
}
