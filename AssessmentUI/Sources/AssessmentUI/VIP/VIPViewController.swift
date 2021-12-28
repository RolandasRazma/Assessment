//
//  VIPViewController.swift
//  
//
//  Created by Rolandas Razma on 27/12/2021.
//

import Foundation
import UIKit

public protocol VIPViewController: UIViewController {
    
    associatedtype DataInput
    
    static func storyboard(bundle: Bundle) -> UIStoryboard
    static func instantiate(dataInput: DataInput) -> Self
    static func instantiate(dataInput: DataInput, bundle: Bundle) -> Self
    
    func configure(dataInput: DataInput)
    
}

public extension VIPViewController {
    
    static func storyboard(bundle: Bundle) -> UIStoryboard {
        let name: Substring = String(describing: self).dropLast(14)  // Droping "ViewController". "SomeViewController" storyboard should be "Some.storyboard"
        return UIStoryboard(name: String(name), bundle: bundle)
    }
    
    static func instantiate(dataInput: DataInput) -> Self {
        return instantiate(dataInput: dataInput, bundle: Bundle(for: self))
    }
    
    static func instantiate(dataInput: DataInput, bundle: Bundle) -> Self {
        assert(Thread.isMainThread)
        
        let viewControler: Self = storyboard(bundle: bundle).instantiateInitialViewController() as! Self
        viewControler.configure(dataInput: dataInput)
        
        return viewControler
    }
    
}
