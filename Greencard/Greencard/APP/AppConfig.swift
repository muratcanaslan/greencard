//
//  AppConfig.swift
//  Greencard
//
//  Created by Murat Can ASLAN on 3.03.2024.
//

import UIKit

final class AppConfiguration {
    static let shared = AppConfiguration()
    
    private init() { }
    
    func configure() {
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        let titleStyle: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.textColor,
            .font: UIFont.button
        ]

        let navAppearance = UINavigationBar.appearance()
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = titleStyle
        appearance.shadowColor = .clear
        appearance.setBackIndicatorImage(UIImage(resource: .iconBack), transitionMaskImage: UIImage(resource: .iconBack))
        navAppearance.scrollEdgeAppearance = appearance
        navAppearance.compactAppearance = appearance
        navAppearance.standardAppearance = appearance
        navAppearance.backItem?.title = ""
        navAppearance.isTranslucent = false
        
    }
}
