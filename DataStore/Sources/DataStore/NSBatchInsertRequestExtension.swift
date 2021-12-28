//
//  NSBatchInsertRequestExtension.swift
//  DataStore
//
//  Created by Rolandas Razma on 27/12/2021.
//

import Foundation
import CoreData

public extension NSBatchInsertRequest {
    
    convenience init<T: NSManagedObject>(entity: T.Type, handler: @escaping (_ managedObject: T) -> Bool) {
        self.init(entity: T.entity()) { (managedObject: NSManagedObject) -> Bool in
            guard let managedObject = managedObject as? T else { return false }
            return handler(managedObject)
        }
    }
    
}
