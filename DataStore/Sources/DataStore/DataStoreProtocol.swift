//
//  DataStoreProtocol.swift
//  DataStore
//
//  Created by Rolandas Razma on 27/12/2021.
//

import Foundation
import CoreData

public protocol DataStoreProtocol {
    
    var viewContext: NSManagedObjectContext { get }
    
    @discardableResult
    func perform(_ batchInsertRequest: NSBatchInsertRequest, mergePolicy: NSMergePolicy) async throws -> [NSManagedObjectID]
    
}
