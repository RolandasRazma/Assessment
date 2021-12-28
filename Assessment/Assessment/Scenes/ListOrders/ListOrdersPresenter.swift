//
//  ListOrdersPresenter.swift
//  Assessment
//
//  Created by Rolandas Razma on 27/12/2021.
//

import Foundation
import Combine
import AssessmentUI
import CoreData
import DataStore

final class ListOrdersPresenter {
    
    @Published private(set) var viewModel: ListOrders.ViewModel?
	
    private var disposables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(_ interactor: ListOrdersInteractorOutput) {
        interactor
            .modelPublisher
            .map({ return ListOrders.ViewModel(model: $0) })
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.viewModel, on: self)
            .store(in: &disposables)
    }
	
}

fileprivate extension ListOrders.ViewModel {
    
    init(model: ListOrders.Model) {
        let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
        fetchRequest.sortDescriptors = [ NSSortDescriptor(keyPath: \Order.createdAt, ascending: false) ]
        fetchRequest.fetchBatchSize = 20
        
        self.fetchRequest = fetchRequest
        self.managedObjectContext = model.dataStore.viewContext
        self.noOrders = ((try? model.dataStore.viewContext.count(for: fetchRequest)) ?? 0) == 0
    }
    
}
