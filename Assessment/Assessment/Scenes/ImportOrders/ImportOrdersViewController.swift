//
//  ImportOrdersViewController.swift
//  Assessment
//
//  Created by Rolandas Razma on 27/12/2021.
//

import UIKit
import Combine
import AssessmentUI

public final class ImportOrdersViewController: UIViewController, VIPViewController {
    
    @IBOutlet private var importContainer: UIView!
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!
    
    fileprivate var interactor: ImportOrdersInteractorInput!
    fileprivate var presenter: ImportOrdersPresenter!
    fileprivate var router: ImportOrdersRouter!
    
    private var disposables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    @IBAction private func startImport() {
        interactor.startImport()
    }
    
    // MARK: - ViewController
    
    fileprivate func bind() {
        
        presenter.$viewModelImport.sink { [weak self] (viewModel: Work.ViewModel<GenericErrorRepresentable>) in
			guard let self = self else { return }
            
            switch viewModel {
            case .active:
                self.activityIndicatorView.startAnimating()
                self.importContainer.isHidden = true
                
            case .failed(error: let error):
                self.activityIndicatorView.stopAnimating()
                self.importContainer.isHidden = false
                self.router.show(error: error)
                
            case .finished:
                self.router.completed()
                
            case .idle:
                self.activityIndicatorView.stopAnimating()
                
            }
            
        }.store(in: &disposables)
        
    }
        
}

extension ImportOrdersViewController {
	
	public func configure(dataInput: ImportOrders.Input) {
        let interactor: ImportOrdersInteractor = ImportOrdersInteractor(dataInput: dataInput)
        let presenter: ImportOrdersPresenter = ImportOrdersPresenter(interactor: interactor)
        let router: ImportOrdersRouter = ImportOrdersRouter(viewController: self, dataStore: interactor)
        
        configure(interactor: interactor, presenter: presenter, router: router)
    }
    
    func configure(interactor: ImportOrdersInteractorInput, presenter: ImportOrdersPresenter, router: ImportOrdersRouter) {
        self.interactor = interactor
        self.presenter = presenter
        self.router = router
        
        loadViewIfNeeded()
        
        bind()
    }
	
}
