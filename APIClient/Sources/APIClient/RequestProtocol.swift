//
//  RequestProtocol.swift
//  APIClient
//
//  Created by Rolandas Razma on 27/12/2021.
//

import Foundation
@_exported import struct Alamofire.HTTPMethod

public protocol RequestProtocol {
    
    var path: String { get }
    var method: HTTPMethod { get }
    
}
