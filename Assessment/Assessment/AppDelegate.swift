//
//  AppDelegate.swift
//  Assessment
//
//  Created by Rolandas Razma on 27/12/2021.
//

import UIKit
import CoreData
import DataStore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ListOrdersViewController.instantiate(dataInput: ListOrders.Input(dataStore: DataStore.shared))
        window?.makeKeyAndVisible()
        
        return true
    }
    
}
