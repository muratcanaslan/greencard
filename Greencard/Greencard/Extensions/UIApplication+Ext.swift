//
//  UIApplication+Ext.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 3.03.2024.
//

import UIKit

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController) -> UIViewController? {
      if let navigationController = controller as? UINavigationController {
        return topViewController(controller: navigationController.visibleViewController)
      }

      if let tabController = controller as? UITabBarController {
        if let selected = tabController.selectedViewController {
          return topViewController(controller: selected)
        }
      }

      if let presented = controller?.presentedViewController {
        return topViewController(controller: presented)
      }

      return controller
    }
    
    func openAppStore(for appId: String) {
        let appStoreUrl = "https://itunes.apple.com/app/\(appId)"
        guard let url = URL(string: appStoreUrl) else {
            return
        }
        
        DispatchQueue.main.async {
            if self.canOpenURL(url) {
                self.open(url)
            }
        }
    }
}
