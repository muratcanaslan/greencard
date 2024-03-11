//
//  NavigationManager.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 3.03.2024.
//

import UIKit

final class NavigationManager {
    
    class func getCurrentWindow() -> UIWindow {
        var window = UIApplication.shared.delegate?.window ?? UIApplication.shared.keyWindow
        if window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.makeKeyAndVisible()
        }
        return window!
    }
    
    class func show(_ vc: UIViewController) {
        let window = NavigationManager.getCurrentWindow()
        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(with: window, duration: 0.2, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    class func start() {
        let vc = UINavigationController(rootViewController: HomeViewController())
        NavigationManager.show(vc)
    }
}
 
