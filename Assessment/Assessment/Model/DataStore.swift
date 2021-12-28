//
//  DataStore.swift
//  Assessment
//
//  Created by Rolandas Razma on 27/12/2021.
//

import UIKit
import DataStore

extension DataStore {
    
    static let shared: DataStore = DataStore()
    
    convenience init() {
        
        #if targetEnvironment(simulator)
        // Faster iterration for development
        // try! DataStore.destroyPersistentContainer(withName: "Assessment")
        #endif
        
        do {
            try self.init(persistentContainerName: "Assessment", bundle: Bundle.main)
            
            do {
                try self.load()
            } catch {
                // Failing to load container
                // Possible reason: model update needed (shcema changes)
                // deppending on situation (for example all data can be reimported) it might be simpler to reset whole container
                
                do {
                    try DataStore.destroyPersistentContainer(withName: "Assessment")
                    try self.load()
                } catch {
                    // No way to recover from this
                    fatalError()
                }
            }
        } catch {
            // No way to recover from this
            fatalError()
        }
        
    }
    
}
