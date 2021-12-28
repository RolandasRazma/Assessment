//
//  ImportOrdersModels.swift
//  Assessment
//
//  Created by Rolandas Razma on 27/12/2021.
//

import UIKit
import APIClient
import protocol DataStore.DataStoreProtocol

public enum ImportOrders {

    public struct Input {
        let dataStore: DataStoreProtocol
        let completionHandler: () -> Void
    }
    
}


extension ImportOrders {
    
    struct Request: RequestProtocol {
        let path: String = "/orders"
        let method: HTTPMethod = .get
    }
    
    struct Resonse: Decodable {
        
        struct Order {
            let orderId: String
            let currency: String
            let amount: NSDecimalNumber
            let orderType: Assessment.Order.OrderType
            let orderStatus: Assessment.Order.OrderStatus
            let createdAt: Date
        }
        
        let orders: [Order]
    }
    
}

extension ImportOrders.Resonse.Order: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case orderId
        case currency       // Could be enum
        case amount
        case orderType
        case orderStatus
        case createdAt
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        orderId = try values.decode(String.self, forKey: .orderId)
        currency = try values.decode(String.self, forKey: .currency)
        amount = NSDecimalNumber(string: try values.decode(String.self, forKey: .amount))
        
        let orderType: String = try values.decode(String.self, forKey: .orderType)
        self.orderType = Order.OrderType(rawValue: orderType) ?? Order.OrderType.other // <- better approach would be to use something like Apollo have `case __unknown(rawValue: String)`
        
        let orderStatus: String = try values.decode(String.self, forKey: .orderStatus)
        self.orderStatus = Order.OrderStatus(rawValue: orderStatus) ?? Order.OrderStatus.other // <- better approach would be to use something like Apollo have `case __unknown(rawValue: String)`
        
        createdAt = Date(timeIntervalSince1970: TimeInterval(try values.decode(String.self, forKey: .createdAt))! / 1000.0)
    }
    
}

extension Order {
    
    func update(with order: ImportOrders.Resonse.Order) {
        self.orderId = order.orderId
        self.currency = order.currency
        self.amount = order.amount
        self.orderType = order.orderType
        self.orderStatus = order.orderStatus
        self.createdAt = order.createdAt
    }
    
}
