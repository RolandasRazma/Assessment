//
//  APIClient.swift
//  Assessment
//
//  Created by Rolandas Razma on 27/12/2021.
//

import Foundation
import APIClient

final class APIClient: APIClientProtocol {
    
    let baseURL: URL
    
    // Usually URL comes from some config based on build configuration (repelase/production/etc) but don't want to overcomplicate things...
    
    init(baseURL: URL = URL(string: "https://assessments.stage.copper.co/ios")!) {
        self.baseURL = baseURL
    }
    
}
