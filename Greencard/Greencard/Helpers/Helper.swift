//
//  Helper.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 9.03.2024.
//

import UIKit

struct Helper {
    static func getDeviceVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    static func getDeviceModel() -> String {
        return UIDevice.current.name
    }
    
    static func getDeviceId() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    static func getBuildNumebr() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "none"
    }
}
