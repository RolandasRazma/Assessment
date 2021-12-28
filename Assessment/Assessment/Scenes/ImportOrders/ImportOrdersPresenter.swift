//
//  ImportOrdersPresenter.swift
//  Assessment
//
//  Created by Rolandas Razma on 27/12/2021.
//

import Foundation
import Combine
import AssessmentUI

final class ImportOrdersPresenter {
    
    @Published private(set) var viewModelImport: Work.ViewModel<GenericErrorRepresentable> = .idle
    
    private var disposables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(interactor: ImportOrdersInteractorOutput) {
        
        interactor
            .modelImportPublisher
            .map({ return Work.ViewModel(model: $0) })
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .weakAssign(to: \.viewModelImport, on: self)
            .store(in: &disposables)
        
    }
	
}
