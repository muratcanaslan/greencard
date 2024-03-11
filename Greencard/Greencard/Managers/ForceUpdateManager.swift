//
//  ForceUpdateManager.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 10.03.2024.
//

import UIKit
import FirebaseRemoteConfig

enum UpdateStatus {
    case shouldUpdate
    case noUpdate
}

class ForceUpdateManager {
    
    static let FORCE_UPDATE_STORE_URL = "force_update_store_url"
    static let FORCE_UPDATE_CURRENT_VERSION = "force_update_current_version"
    static let IS_FORCE_UPDATE_REQUIRED = "is_force_update_required"
    static let APP_ID = "app_id"

    class func getAppVersion() -> String {
        let version = "\(Bundle.appVersionBundle)(\(Bundle.appBuildBundle))"
        return version
    }
    
    class func getAppId(completion: (String?) -> Void) {
        let remoteConfig = RemoteConfig.remoteConfig()
        guard let appId = remoteConfig[ForceUpdateManager.APP_ID].stringValue else {
            completion(nil)
            return
        }
        completion(appId)
    }
    
    class func check() -> UpdateStatus {
        let remoteConfig = RemoteConfig.remoteConfig()
        let forceRequired = remoteConfig[ForceUpdateManager.IS_FORCE_UPDATE_REQUIRED].boolValue
        
        if(forceRequired == true){
            guard let currentAppStoreVersion = remoteConfig[ForceUpdateManager.FORCE_UPDATE_CURRENT_VERSION].stringValue else {
                return .noUpdate
            }
            
            let appVersion = getAppVersion()
            
            if(currentAppStoreVersion > appVersion){
                let url = remoteConfig[ForceUpdateManager.FORCE_UPDATE_STORE_URL].stringValue
                if(url != nil){
                    return .shouldUpdate
                }
            }
        }
        return .noUpdate
    }
    
    class func setupRemoteConfig(){
        
        let remoteConfig = RemoteConfig.remoteConfig()
        
        let defaults : [String : Any] = [
            ForceUpdateManager.IS_FORCE_UPDATE_REQUIRED : false,
            ForceUpdateManager.FORCE_UPDATE_CURRENT_VERSION : "1.0.0(1)",
            ForceUpdateManager.FORCE_UPDATE_STORE_URL : "https://www.google.com"
        ]
        
        let expirationDuration = 0
        
        remoteConfig.setDefaults(defaults as? [String : NSObject])
        
        remoteConfig.fetch(withExpirationDuration: TimeInterval(expirationDuration)) { (status, error) in
            if status == .success {
                remoteConfig.activate()
            } else {
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }
    
    class func checkVersion() {
        if ForceUpdateManager.check() == .shouldUpdate {
            let alert = UIAlertController(title: "New version available!",
                                          message: "Exciting update with brand-new features is now available! Upgrade now to experience our latest enhancements and take your app to the next level.",
                                          preferredStyle: .alert)
            let action = UIAlertAction(title: "Update", style: .default, handler: goToAppStore)
            alert.addAction(action)
            action.setValue(UIColor.black, forKey: "titleTextColor")
            
            if let topViewController = UIApplication.topViewController(), topViewController is UIAlertController {
                return
            }
            UIApplication.topViewController()?.present(alert, animated: true)
        }
    }
    
    class func goToAppStore(action: UIAlertAction) {
        getAppId { appId in
            if let appId, !appId.isEmpty {
                UIApplication.shared.openAppStore(for: appId)
            }
        }
    }
}
