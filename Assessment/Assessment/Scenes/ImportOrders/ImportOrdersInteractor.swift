//
//  ImportOrdersInteractor.swift
//  Assessment
//
//  Created by Rolandas Razma on 27/12/2021.
//

import Foundation
import Combine
import AssessmentUI
import DataStore

protocol ImportOrdersInteractorInput: AnyObject {
    func startImport()
}

protocol ImportOrdersInteractorOutput: AnyObject {
    var modelImportPublisher: Published<Work.Model<Void, Error>>.Publisher { get }
}

final class ImportOrdersInteractor: ImportOrdersDataStore {
	@Published private var modelImport: Work.Model<Void, Error> = .idle
	
    private let worker: ImportOrdersWorker
    
    let dataInput: ImportOrders.Input
    
    init(dataInput: ImportOrders.Input, worker: ImportOrdersWorker? = nil) {
		self.dataInput = dataInput
        self.worker = worker ?? ImportOrdersWorker(dataStore: dataInput.dataStore)
    }
    
}

extension ImportOrdersInteractor: ImportOrdersInteractorInput {
    
    func startImport() {
        self.modelImport = .active
        
        worker.importData { [weak self] (result: Result<Void, Error>) in
            guard let `self` = self else { return }

            switch result {
            case .success:
                self.modelImport = .finished(())
                
            case .failure(let error):
                self.modelImport = .failed(error)
                
            }
        }
    }
    
}

extension ImportOrdersInteractor: ImportOrdersInteractorOutput {
    
    var modelImportPublisher: Published<Work.Model<Void, Error>>.Publisher {
        return $modelImport
    }
    
}
