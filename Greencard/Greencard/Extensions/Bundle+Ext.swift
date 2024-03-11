//
//  Bundle+Ext.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 3.03.2024.
//

import UIKit

extension Bundle {

    static var appVersionBundle: String {
        guard
            let info = Bundle.main.infoDictionary,
            let version = info["CFBundleShortVersionString"] as? String
            else { return "" }
        return version
    }

    static var appBuildBundle: String {
        guard
            let info = Bundle.main.infoDictionary,
            let version = info["CFBundleVersion"] as? String
            else { return "" }
        return version
    }
}
