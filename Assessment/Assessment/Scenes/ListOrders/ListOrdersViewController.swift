//
//  ListOrdersViewController.swift
//  Assessment
//
//  Created by Rolandas Razma on 27/12/2021.
//

import UIKit
import Combine
import AssessmentUI

public final class ListOrdersViewController: UIViewController, VIPViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private var ordersDataSource: TableViewDataSource<Order, ListOrdersCellConfigurator>?
    
    fileprivate var interactor: ListOrdersInteractorInput!
    fileprivate var presenter: ListOrdersPresenter!
    fileprivate var router: ListOrdersRouter!
    
    private var disposables: Set<AnyCancellable> = Set<AnyCancellable>()
	
    // MARK: - ViewController
    
    fileprivate func bind() {
        
        presenter.$viewModel.sink { [weak self] (viewModel: ListOrders.ViewModel?) in
			guard let self = self, let viewModel = viewModel else { return }
			
            self.ordersDataSource = TableViewDataSource<Order, ListOrdersCellConfigurator>(tableView: self.tableView,
                                                                                           managedObjectContext: viewModel.managedObjectContext,
                                                                                           fetchRequest: viewModel.fetchRequest,
                                                                                           cellConfigurator: ListOrdersCellConfigurator())
            
            if viewModel.noOrders {
                self.router.importOrders()
            }
        }.store(in: &disposables)
        
    }
    
    // MARK: - UIViewController
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.flashScrollIndicators()
    }
    
}

extension ListOrdersViewController {
	
	public func configure(dataInput: ListOrders.Input) {
        let interactor: ListOrdersInteractor = ListOrdersInteractor(dataInput: dataInput)
        let presenter: ListOrdersPresenter = ListOrdersPresenter(interactor)
        let router: ListOrdersRouter = ListOrdersRouter(viewController: self, dataStore: interactor)
        
        configure(interactor: interactor, presenter: presenter, router: router)
    }
    
    func configure(interactor: ListOrdersInteractorInput, presenter: ListOrdersPresenter, router: ListOrdersRouter) {
        self.interactor = interactor
        self.presenter = presenter
        self.router = router
        
        loadViewIfNeeded()
        
        bind()
    }
	
}
