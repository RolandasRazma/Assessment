//
//  AmountFormatter.swift
//  AssessmentUI
//
//  Created by Rolandas Razma on 27/12/2021.
//

import Foundation

public class AmountFormatter: NumberFormatter {
    
    public func string(from number: NSDecimalNumber) -> String {

        // Formating not to locale, but keeping NumberFormatter interface
        let currencyCode: String = self.currencyCode
        self.currencyCode = nil
        
        defer { self.currencyCode = currencyCode }
        
        // missing "M", "B", etc...
        
        if number.decimalValue >= 1000.0, let stringValue: String = self.string(for: number.dividing(by: 1000.0)) {
            return "\(stringValue)K \(currencyCode)" // <- "K" should be localized
        }
        
        return (self.string(for: number) ?? "") + " \(currencyCode)"
    }
    
    // MARK: - NSObject
    
    public override init() {
        super.init()
        
        self.locale = Locale.current
        self.maximumFractionDigits = 4
    }
    
    // MARK: - NSCoder
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
