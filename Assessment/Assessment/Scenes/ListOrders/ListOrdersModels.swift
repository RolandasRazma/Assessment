//
//  ListOrdersModels.swift
//  Assessment
//
//  Created by Rolandas Razma on 27/12/2021.
//

import UIKit
import CoreData
import protocol DataStore.DataStoreProtocol

public enum ListOrders {

    public struct Input {
        let dataStore: DataStoreProtocol
    }
	    
    struct Model {
        let dataStore: DataStoreProtocol
    }
    
    struct ViewModel: Equatable {
        let fetchRequest: NSFetchRequest<Order>
        let managedObjectContext: NSManagedObjectContext
        
        let noOrders: Bool
    }
    
}
