//
//  DataStore.swift
//  DataStore
//
//  Created by Rolandas Razma on 27/12/2021.
//

import CoreData

public class DataStore {
    
    public enum DataStoreError: LocalizedError {
        case containerNotFound
        case invalidContainer
    }
    
    private let persistentContainer: NSPersistentContainer
    
    public class func destroyPersistentContainer(withName name: String) throws {
        let defaultDirectoryURL: URL = NSPersistentContainer.defaultDirectoryURL()
        if FileManager.default.fileExists(atPath: defaultDirectoryURL.path) {
            try FileManager.default.removeItem(at: defaultDirectoryURL)
        }
    }
    
    public init(persistentContainerName: String, bundle: Bundle) throws {
        
        guard let modelURL: URL = bundle.url(forResource: persistentContainerName, withExtension: "momd") else {
            throw DataStoreError.containerNotFound
        }
        
        guard let managedObjectModel: NSManagedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            throw DataStoreError.invalidContainer
        }
        
        persistentContainer = NSPersistentContainer(name: persistentContainerName, managedObjectModel: managedObjectModel)
        
    }
    
    public func load() throws {
        // Loading is actually synchronous unless you ask it to be otherwise
        // To simplify flow on consumer (app) convert it to one shot operation
        
        var loadError: Error?
        persistentContainer.loadPersistentStores { (_: NSPersistentStoreDescription, error: Error?) in
            loadError = error
        }
        
        if let loadError = loadError {
            throw loadError
        }
    }
    
}

extension DataStore: DataStoreProtocol {
    
    public var viewContext: NSManagedObjectContext { persistentContainer.viewContext }
    
    @discardableResult
    public func perform(_ batchInsertRequest: NSBatchInsertRequest, mergePolicy: NSMergePolicy) async throws -> [NSManagedObjectID] {
        precondition(batchInsertRequest.resultType == .objectIDs)
        
        return try await withCheckedThrowingContinuation { (checkedContinuation: CheckedContinuation<[NSManagedObjectID], Error>) in
            let backgroundContext = self.persistentContainer.newBackgroundContext()
            backgroundContext.mergePolicy = mergePolicy
            
            backgroundContext.perform {
                do {
                    let batchInsertResult: NSBatchInsertResult = try backgroundContext.execute(batchInsertRequest) as! NSBatchInsertResult
                    let managedObjectIDs: [NSManagedObjectID] = batchInsertResult.result as! [NSManagedObjectID] // it's fine to force unweap as there is precondition
                    
                    if managedObjectIDs.isEmpty == false {
                        // batch update with mergeChanges might actualy not update objects in context if they already registered
                        // and they have to be force loadeded by itterating registeredObjects
                        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSInsertedObjectsKey: managedObjectIDs], into: [ self.persistentContainer.viewContext ])
                    }
                    
                    checkedContinuation.resume(returning: managedObjectIDs)
                } catch {
                    checkedContinuation.resume(throwing: error)
                }
            }
        }
    }
    
}

extension DataStore.DataStoreError {
    
    public var errorDescription: String? {
        switch self {
        case .containerNotFound:
            return "Container Not Found"
            
        case .invalidContainer:
            return "Invalid Container"
            
        }
    }
    
}
