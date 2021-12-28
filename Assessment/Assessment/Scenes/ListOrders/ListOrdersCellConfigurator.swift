//
//  ListOrdersCellConfigurator.swift
//  Assessment
//
//  Created by Rolandas Razma on 27/12/2021.
//

import UIKit
import CoreData
import AssessmentUI

struct ListOrdersCellConfigurator: TableViewCellConfigurator {
    typealias ManagedObject = Order
    
    // Assuming date in designs just placeholder - it should be formatted according users locale
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMMdjmm", options: 0, locale: Locale.current)
        
        return dateFormatter
    }()
    
    func cell(tableView: UITableView, object: ManagedObject, indexPath: IndexPath) -> UITableViewCell {
        let listOrdersCell: ListOrdersCell = tableView.dequeueReusableCell(withIdentifier: "ListOrdersCell", for: indexPath) as! ListOrdersCell
        listOrdersCell.configure(with: object, dateFormatter: dateFormatter)
        
        return listOrdersCell
    }
    
}

extension ListOrdersCell {
    
    func configure(with model: Order, dateFormatter: DateFormatter) {
        
        // Those can't be nil as model don't allow nil imports
        // But adding precondition just in case
        precondition(model.currency != nil)
        precondition(model.amount != nil)
        
        let numberFormatter: AmountFormatter = AmountFormatter()
        numberFormatter.currencyCode = model.currency
        
        switch model.orderType {
        case .deposit:
            infoLabel.text = "In \(model.currency!)"
            amountLabel.text = "\(numberFormatter.plusSign ?? "+")\(numberFormatter.string(from: model.amount!))"
            
        case .buy:
            infoLabel.text = "ETH -> \(model.currency!)" // Missing second currency - according to task it is hardcoded to "ETH"??
            amountLabel.text = "\(numberFormatter.plusSign ?? "+")\(numberFormatter.string(from: model.amount!))"
            
        case .sell:
            infoLabel.text = "\(model.currency!) -> ETH" // Missing second currency - according to task it is hardcoded to "ETH"??
            amountLabel.text = "\(numberFormatter.minusSign ?? "-")\(numberFormatter.string(from: model.amount!))"
            
        case .withdraw:
            infoLabel.text = "Out \(model.currency!)"
            amountLabel.text = "\(numberFormatter.minusSign ?? "-")\(numberFormatter.string(from: model.amount!))"
            
        case .none, .other:
            assertionFailure("This thould not happen, please add new case")
            infoLabel.text = model.currency!
            
        }
        
        dateLabel.text = dateFormatter.string(from: model.createdAt!)
        
        switch model.orderStatus {
        case .executed:
            statusLabel.text = "Executed" // <- should be localized
            
        case .canceled:
            statusLabel.text = "Canceled"
            
        case .approved:
            statusLabel.text = "Approved"
            
        case .processing:
            statusLabel.text = "Processing"
            
        case .none, .other:
            assertionFailure("This thould not happen, please add new case")
            statusLabel.text = ""
            
        }
    }
    
}
