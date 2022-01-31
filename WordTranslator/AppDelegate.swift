//
//  AppDelegate.swift
//  WordTranslator
//
//  Created by Артем Мак on 09.01.2022.
//  Copyright © 2022 Артем Мак. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let wordSearchViewController = SearchViewController()
        let navController = UINavigationController(rootViewController: wordSearchViewController)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        return true
    }
}

