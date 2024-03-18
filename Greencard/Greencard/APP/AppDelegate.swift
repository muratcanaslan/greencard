//
//  AppDelegate.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 3.03.2024.
//

import UIKit
import RevenueCat
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        FirebaseApp.configure()
        
        ForceUpdateManager.setupRemoteConfig()
        ForceUpdateManager.checkVersion()
        
        AppConfiguration.shared.configure()
        
        Purchases.configure(withAPIKey: ConstantManager.revenue_cat_public_api_key)

        IAPManager.shared.start()
        
        UserManager.shared.start()
        
        StoreKitManager.shared.start()
        
        NavigationManager.start()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        ForceUpdateManager.setupRemoteConfig()
        ForceUpdateManager.checkVersion()
    }
}

