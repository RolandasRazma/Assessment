//
//  ListOrdersRouter.swift
//  Assessment
//
//  Created by Rolandas Razma on 27/12/2021.
//

import UIKit

protocol ListOrdersDataStore {
    var dataInput: ListOrders.Input { get }
}

protocol ListOrdersDataPassing {
    var dataStore: ListOrdersDataStore { get }
}

final class ListOrdersRouter: ListOrdersDataPassing {
    private unowned let viewController: UIViewController
	let dataStore: ListOrdersDataStore
    
    init(viewController: UIViewController, dataStore: ListOrdersDataStore) {
        self.viewController = viewController
        self.dataStore = dataStore
    }
    
    func importOrders() {
        let dataInput = ImportOrders.Input(dataStore: dataStore.dataInput.dataStore) { [weak self] in
            self?.viewController.presentedViewController?.dismiss(animated: true)
        }
        
        let ImportOrdersViewController: ImportOrdersViewController = ImportOrdersViewController.instantiate(dataInput: dataInput)
        viewController.present(ImportOrdersViewController, animated: false)
    }
    
}
