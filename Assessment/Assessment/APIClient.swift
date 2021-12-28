//
//  APIClient.swift
//  Assessment
//
//  Created by Rolandas Razma on 27/12/2021.
//

import Foundation
import Alamofire

protocol APIClientProtocol {
    
}

protocol RequestProtocol {
    
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
    
}
