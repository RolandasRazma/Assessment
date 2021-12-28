//
//  OrderExtension.swift
//  Assessment
//
//  Created by Rolandas Razma on 27/12/2021.
//

import Foundation

extension Order {
    
    // Designs have something like "convert" - but there is no case in API (or task description) and there is no seccond currency
    // It would technically fall under "other" with such setup as it's "unknown" case from server
    // It is a good question what to do with those transacions, on one hand you want app to be forward compatible
    // on other hand you don't want to show to user case you don't know how to handle - might be expensive mistake...
    // I would probably version API and not return transactions to clients that they can't handle, and force app update...
    
    enum OrderType: String {
        case deposit
        case withdraw
        case buy
        case sell
        case other // <- better approach would be to use something like Apollo have `case __unknown(rawValue: String)`
    }
    
    enum OrderStatus: String, Decodable {
        case executed
        case canceled
        case approved
        case processing
        case other // <- better approach would be to use something like Apollo have `case __unknown(rawValue: String)`
    }
    
    var orderType: OrderType? {
        set { self.orderTypeRawValue = newValue?.rawValue }
        get {
            guard let orderTypeRawValue = self.orderTypeRawValue else { return nil }
            return OrderType(rawValue: orderTypeRawValue)
        }
    }
    
    var orderStatus: OrderStatus? {
        set { self.orderStatusRawValue = newValue?.rawValue }
        get {
            guard let orderStatusRawValue = self.orderStatusRawValue else { return nil }
            return OrderStatus(rawValue: orderStatusRawValue)
        }
    }
    
}
