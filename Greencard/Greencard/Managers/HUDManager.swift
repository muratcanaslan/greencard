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
        ProgressHUD.colorAnimation = .blueColor
        ProgressHUD.colorProgress = .blueColor.withAlphaComponent(0.5)
        ProgressHUD.animate(nil, .squareCircuitSnake, interaction: false)
    }
    
    class func hideAnimation() {
        ProgressHUD.dismiss()
    }
}
