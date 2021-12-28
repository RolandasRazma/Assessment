//
//  ListOrdersInteractor.swift
//  Assessment
//
//  Created by Rolandas Razma on 27/12/2021.
//  
//

import Foundation
import Combine

protocol ListOrdersInteractorInput: AnyObject {
    
}

protocol ListOrdersInteractorOutput: AnyObject {
    var modelPublisher: Published<ListOrders.Model>.Publisher { get }
}

final class ListOrdersInteractor: ListOrdersDataStore {
	@Published var model: ListOrders.Model
	
    let dataInput: ListOrders.Input
    
    init(dataInput: ListOrders.Input) {
		self.dataInput = dataInput
        self.model = ListOrders.Model(dataStore: dataInput.dataStore)
    }
    
}

extension ListOrdersInteractor: ListOrdersInteractorInput {
    
}

extension ListOrdersInteractor: ListOrdersInteractorOutput {
    
    var modelPublisher: Published<ListOrders.Model>.Publisher {
        return $model
    }
    
}
