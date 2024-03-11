//
//  HUDManager.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 11.03.2024.
//

import UIKit
import ProgressHUD

final class HUDManager {
        
    class func showAnimation() {
        ProgressHUD.colorAnimation = .greenColor
        ProgressHUD.animate(nil, .barSweepToggle, interaction: false)
    }
    
    class func hideAnimation() {
        ProgressHUD.dismiss()
    }
}
