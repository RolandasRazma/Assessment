//
//  TableViewDataSource.swift
//  AssessmentUI
//
//  Created by Rolandas Razma on 27/12/2021.
//

import UIKit
import CoreData

public protocol TableViewCellConfigurator {
    associatedtype ManagedObject: NSManagedObject
    
    func cell(tableView: UITableView, object: ManagedObject, indexPath: IndexPath) -> UITableViewCell
    
}

public final class TableViewDataSource<ManagedObject, Configurator: TableViewCellConfigurator>: NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate where Configurator.ManagedObject == ManagedObject {
    
    private weak var tableView: UITableView!
    
    private let cellConfigurator: Configurator
    
    private let fetchedResultsController: NSFetchedResultsController<ManagedObject>
    
    public init(tableView: UITableView, managedObjectContext: NSManagedObjectContext, fetchRequest: NSFetchRequest<ManagedObject>, cellConfigurator: Configurator) {
        self.tableView = tableView
        self.cellConfigurator = cellConfigurator
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        self.fetchedResultsController = fetchedResultsController
        
        super.init()
        
        fetchedResultsController.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func object(at indexPath: IndexPath) -> ManagedObject {
        return fetchedResultsController.object(at: indexPath)
    }
    
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellConfigurator.cell(tableView: tableView, object: object(at: indexPath), indexPath: indexPath)
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            
        default:
            return
            
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            // tableView.moveRow(at: , to: ) might actualy crash in some cases with out of index
            
        case .update:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath ?? indexPath!], with: .fade)
            
        @unknown default:
            assertionFailure()
            
        }
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}
