//
//  ImportOrdersWorker.swift
//  Assessment
//
//  Created by Rolandas Razma on 27/12/2021.
//

import Foundation
import DataStore
import APIClient
import CoreData

final class ImportOrdersWorker {
    
    let apiClient: APIClientProtocol
    let dataStore: DataStoreProtocol
    
    private var importTask: Task<Void, Error>?
        
    init(apiClient: APIClientProtocol = APIClient(), dataStore: DataStoreProtocol = DataStore.shared) {
        self.apiClient = apiClient
        self.dataStore = dataStore
    }
    
    deinit {
        importTask?.cancel()
    }
    
    func importData(completionHandler: @escaping (_ result: Result<Void, Error>) -> Void) {
        
        importTask?.cancel()
        importTask = Task.detached {
            
            do {
                // Depending on size of data we could import as we download to save some RAM, but don't want to overcomplicate...
                let resonse: ImportOrders.Resonse = try await self.apiClient.request(ImportOrders.Request())
                
                var leftObjects: Int = resonse.orders.count - 1
                
                let batchInsertRequest = NSBatchInsertRequest(entity: Order.self) { (managedObject: Order) -> Bool in
                    defer { leftObjects -= 1 }
                    
                    managedObject.update(with: resonse.orders[leftObjects])
                    
                    return leftObjects == 0 || Task.isCancelled
                }
                batchInsertRequest.resultType = .objectIDs
                
                guard Task.isCancelled == false else {
                    return
                }
                
                try await self.dataStore.perform(batchInsertRequest, mergePolicy: .overwrite)
                
                completionHandler(.success(()))
            } catch let error {
                completionHandler(.failure(error))
            }
            
        }
        
    }
    
}
