//
//  ATTManager.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 11.03.2024.
//

import Foundation
import AppTrackingTransparency

@available(iOS 14, *)
class ATTManager {
    
    class func send() {
        ATTrackingManager.requestTrackingAuthorization { status in }
    }
}
