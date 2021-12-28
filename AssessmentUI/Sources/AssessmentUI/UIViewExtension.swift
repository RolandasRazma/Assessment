//
//  UIViewExtension.swift
//  AssessmentUI
//
//  Created by Rolandas Razma on 27/12/2021.
//

import UIKit

extension UIView {
    
    @IBInspectable
    dynamic var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius }
    }
    
    @IBInspectable
    dynamic var borderWidth: CGFloat {
        set { layer.borderWidth = newValue }
        get { return layer.borderWidth }
    }
    
    @IBInspectable
    dynamic var borderColor: UIColor? {
        set { layer.borderColor = newValue?.cgColor }
        get { return layer.borderColor != nil ? UIColor(cgColor: layer.borderColor!) : nil }
    }
    
}
