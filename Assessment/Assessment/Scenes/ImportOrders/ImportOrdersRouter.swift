//
//  ImportOrdersRouter.swift
//  Assessment
//
//  Created by Rolandas Razma on 27/12/2021.
//

import UIKit
import struct AssessmentUI.GenericErrorRepresentable

protocol ImportOrdersDataStore {
    var dataInput: ImportOrders.Input { get }
}

protocol ImportOrdersDataPassing {
    var dataStore: ImportOrdersDataStore { get }
}

final class ImportOrdersRouter: ImportOrdersDataPassing {
    private unowned let viewController: UIViewController
	let dataStore: ImportOrdersDataStore
    
    init(viewController: UIViewController, dataStore: ImportOrdersDataStore) {
        self.viewController = viewController
        self.dataStore = dataStore
    }
    
    func show(error: GenericErrorRepresentable) {
        // Not specified in task how to show errors
        let alertController: UIAlertController = UIAlertController(title: error.localizedDescription, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: { _ in }))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    func completed() {
        dataStore.dataInput.completionHandler()
    }
    
}
